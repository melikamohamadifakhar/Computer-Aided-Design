library ieee;
use ieee.std_logic_1164.all;

entity binarymultipleof3_tb is
end binarymultipleof3_tb;

architecture TB_ARCHITECTURE of binarymultipleof3_tb is
    -- Component declaration of the tested unit
    component binarymultipleof3
        port (
            clk : in std_logic;
            rst : in std_logic;
            binary_in : in std_logic_vector(4 downto 0);
            is_multiple_of_3 : out std_logic
        );
    end component;

    -- Stimulus signals - signals mapped to the input and inout ports of tested entity
    signal clk : std_logic := '0';
    signal rst : std_logic := '1';
    signal binary_in : std_logic_vector(4 downto 0) := "00000";
    -- Observed signals - signals mapped to the output ports of tested entity
    signal is_multiple_of_3 : std_logic;

    -- Add your code here ...

    constant CLK_PERIOD : time := 10 ns;

begin

    -- Unit Under Test port map
    UUT : binarymultipleof3
        port map (
            clk => clk,
            rst => rst,
            binary_in => binary_in,
            is_multiple_of_3 => is_multiple_of_3
        );

    -- Clock process
    clk_process: process
    begin
        while now < 100 ns loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
        wait;
    end process clk_process;

    -- Reset process
    rst_process: process
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait;
    end process rst_process;

    -- Test cases
	-- pay attention : outputs are available one clock later !
    stimulus_process: process
    begin
        -- Test case 1: "00000" (multiple of 3)
        binary_in <= "00000";
        wait for 10 ns;

        -- Test case 2: "00011" (multiple of 3)
        binary_in <= "00011";
        wait for 10 ns;

        -- Test case 3: Binary string "00001" (not multiple of 3)
        binary_in <= "00001";
        wait for 10 ns;

        -- Test case 4: Binary string "10000" (not multiple of 3)
        binary_in <= "10000";
        wait for 10 ns;

        -- Add more test cases here...

        wait;
    end process stimulus_process;

end TB_ARCHITECTURE;

configuration TESTBENCH_FOR_binarymultipleof3 of binarymultipleof3_tb is
    for TB_ARCHITECTURE
        for UUT : binarymultipleof3
            use entity work.binarymultipleof3(behavioral);
        end for;
    end for;
end TESTBENCH_FOR_binarymultipleof3;
