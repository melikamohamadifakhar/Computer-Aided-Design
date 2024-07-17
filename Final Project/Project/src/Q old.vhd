library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.Std_Logic_Arith.all;
use ieee.std_logic_unsigned.all;

entity cache is
    port 
    (
        clk           : in std_logic;
        data_to_write : in std_logic_vector(31 downto 0); 
        input         : in std_logic_vector(31 downto 0);
        read_write    : in std_logic;
        hit           : out std_logic;
        data          : out std_logic_vector(31 downto 0);
        dirty         : out std_logic  -- Add dirty bit as an output
    );
end entity cache;

architecture behaviour of cache is
    subtype row is std_logic_vector(145 downto 0);  -- Extend row subtype by 1 bit for the dirty bit
    type memory is array(4096 downto 0) of row;
    signal ram: memory :=(
	 10=>"1000100011010010011100000000110111101000101100100111000101101010000101001010100101111111001001001110000110111000100001011000100001110111000110011",
	 11=>"1110111000110100010011110101111010101001000110100100111011010101000111000011100101101000010110000000100110101111110000101110011011110000011001100",
	 12=>"0111001100010111010111000011001110011100010001110111000101101000010110111101000011101101100101011110001111011111000111011100111110000010111111110",
	 others=>(others=>'0'));
    shared variable index, tag, block_offset : integer;

begin
    process(clk)
    begin
        index := conv_integer(unsigned(input(15 downto 4)));
        tag := conv_integer(unsigned(input(31 downto 16)));
        block_offset := conv_integer(unsigned(input(3 downto 2)));

        if ram(index)(144) = '1' and ram(index)(143 downto 128) = tag then 
            -- Read operation
            if read_write = '0' then
                hit <= '1';
                -- data <= ram(index)(block_offset * 32 + 31 downto block_offset * 32);
                if block_offset = 3 then
                    data <= ram(index)(127 downto 96);
                elsif block_offset = 2 then
                    data <= ram(index)(95 downto 64);
                elsif block_offset = 1 then
                    data <= ram(index)(63 downto 32);
                elsif block_offset = 0 then
                    data <= ram(index)(31 downto 0);
                end if;
            else 
                -- Write operation
                hit <= 'X';
                data <= (others => 'X');
                -- ram(index)(block_offset * 32 + 31 downto block_offset * 32) <= data_to_write;
                if block_offset = 3 then
                    ram(index)(127 downto 96) <= data_to_write;
                elsif block_offset = 2 then
                    ram(index)(95 downto 64) <= data_to_write;
                elsif block_offset = 1 then
                    ram(index)(63 downto 32) <= data_to_write;
                elsif block_offset = 0 then
                    ram(index)(31 downto 0) <= data_to_write;
                end if;
            end if;  
        else
            hit <= '0';
            data <= (others => 'X');
        end if;

        -- Set the dirty bit for write operations
        if read_write = '1' then
            ram(index)(145) <= '1';
        end if;

        -- Output the dirty bit
        dirty <= ram(index)(145);
    end process;

end behaviour;
