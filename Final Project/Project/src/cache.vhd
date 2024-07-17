library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cache is
    port 
    (
        clk: in std_logic;
        input: in std_logic_vector(31 downto 0);
        hit: out std_logic;
        data: out std_logic_vector(31 downto 0);
        write_enable: in std_logic;
        write_data: in std_logic_vector(31 downto 0);
        wb_addr: out std_logic_vector(31 downto 0); -- write-back address
        wb_data: out std_logic_vector(127 downto 0); -- write-back data
        wb_enable: out std_logic; -- write-back enable
        wb_ack: in std_logic -- write-back acknowledge
    );
end entity cache;

architecture behaviour of cache is
    subtype row is std_logic_vector(145 downto 0); -- added dirty bit
    type memory is array(4096 downto 0) of row;
    signal ram: memory := (
        10 => "01000100011010010011100000000110111101000101100100111000101101010000101001010100101111111001001001110000110111000100001011000100001110111000110011",
        11 => "01110111000110100010011110101111010101001000110100100111011010101000111000011100101101000010110000000100110101111110000101110011011110000011001100",
        12 => "00111001100010111010111000011001110011100010001110111000101101000010110111101000011101101100101011110001111011111000111011100111110000010111111110",
        others => (others => '0')
    );
    shared variable index, tag, block_offset: integer;
    signal wb_state: integer range 0 to 2 := 0; -- write-back state machine

begin
    process(clk)
    begin
        if rising_edge(clk) then
            case wb_state is
                when 0 => -- idle state
                    tag := to_integer(unsigned(input(31 downto 16)));
                    index := to_integer(unsigned(input(15 downto 4)));
                    block_offset := to_integer(unsigned(input(3 downto 2)));
                    if (ram(index)(145) = '1' and ram(index)(144 downto 129) = std_logic_vector(to_unsigned(tag, 16))) then
                        hit <= '1';
                        if (block_offset = 3) then
                            data <= ram(index)(128 downto 97);
                        elsif (block_offset = 2) then
                            data <= ram(index)(96 downto 65);
                        elsif (block_offset = 1) then
                            data <= ram(index)(64 downto 33);
                        elsif (block_offset = 0) then
                            data <= ram(index)(32 downto 1);
                        end if;
                    else
                        hit <= '0';
                        data <= (others => 'X');
                        -- write back evicted block if dirty
                        if ram(index)(145) = '1' and ram(index)(0) = '1' then
                            wb_addr <= "01" & std_logic_vector(to_unsigned(index,12)) & ram(index)(144 downto 129) & input(3 downto 2);
                            wb_data <= ram(index)(128 downto 1);
                            wb_enable <= '1';
                            wb_state <= 1; -- go to wait state
                        end if;
                    end if;
                when 1 => -- wait for write-back acknowledge
                    if wb_ack = '1' then
                        wb_enable <= '0';
                        wb_state <= 2; -- go to done state
                    end if;
                when others => -- done state, wait one cycle before going back to idle state
                    wb_state <= 0;
            end case;
        end if;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if write_enable = '1' and wb_state = 0 then -- only perform write when not in write-back state
                tag := to_integer(unsigned(input(31 downto 16)));
                index := to_integer(unsigned(input(15 downto 4)));
                block_offset := to_integer(unsigned(input(3 downto 2)));
                ram(index)(144 downto 129) <= std_logic_vector(to_unsigned(tag, 16));
                ram(index)(145) <= '1';
                ram(index)(0) <= '1'; -- set dirty bit
                if (block_offset = 3) then
                    ram(index)(128 downto 97) <= write_data;
                elsif (block_offset = 2) then
                    ram(index)(96 downto 65) <= write_data;
                elsif (block_offset = 1) then
                    ram(index)(64 downto 33) <= write_data;
                elsif (block_offset = 0) then
                    ram(index)(32 downto 1) <= write_data;
                end if;
            end if;
        end if;
    end process;

end behaviour;
