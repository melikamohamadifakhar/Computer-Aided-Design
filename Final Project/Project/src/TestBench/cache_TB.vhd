library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cache_tb is
end cache_tb;

architecture TB_ARCHITECTURE of cache_tb is
    -- Component declaration of the tested unit
    component cache
        port (
            clk : in std_logic;
            input : in std_logic_vector(31 downto 0);
            hit : out std_logic;
            data : out std_logic_vector(31 downto 0);
            write_enable : in std_logic;
            write_data : in std_logic_vector(31 downto 0);
            wb_addr : out std_logic_vector(31 downto 0);
            wb_data : out std_logic_vector(127 downto 0);
            wb_enable : out std_logic;
            wb_ack : in std_logic
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal clk : std_logic := '0';
    signal input : std_logic_vector(31 downto 0) := (others => '0');
    signal write_enable : std_logic := '0';
    signal write_data : std_logic_vector(31 downto 0) := (others => '0');
    signal wb_ack : std_logic := '0';

    -- Observed signals - signals mapped to the output ports of tested entity
    signal hit : std_logic;
    signal data : std_logic_vector(31 downto 0);
    signal wb_addr : std_logic_vector(31 downto 0);
    signal wb_data : std_logic_vector(127 downto 0);
    signal wb_enable : std_logic;

    constant CLOCK_PERIOD : time := 10 ns;

begin

    -- Unit Under Test port map
    UUT : cache
        port map (
            clk => clk,
            input => input,
            hit => hit,
            data => data,
            write_enable => write_enable,
            write_data => write_data,
            wb_addr => wb_addr,
            wb_data => wb_data,
            wb_enable => wb_enable,
            wb_ack => wb_ack
        );

    -- Clock process
    clk_process : process
    begin
        while now < 1000 ns loop  -- Simulate for 1000 ns
            clk <= '0';
            wait for CLOCK_PERIOD / 2;
            clk <= '1';
            wait for CLOCK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    -- Stimulus process
    stimulus_process : process
    begin
        -- Write operation
        write_enable <= '1';
        write_data <= x"ABCDEFFF";
        wait for CLOCK_PERIOD;
        write_enable <= '0';
        wait for CLOCK_PERIOD;
        
        -- Read operation
        input <= x"12345678";
        wait for CLOCK_PERIOD;
        
        -- Write-back operation
        wb_ack <= '1';
        wait for CLOCK_PERIOD;
        wb_ack <= '0';
        wait for CLOCK_PERIOD;
        
        -- Add more stimulus as needed
        
        wait;
    end process stimulus_process;

    -- Add assertions or checks for expected outputs if desired

end TB_ARCHITECTURE;
