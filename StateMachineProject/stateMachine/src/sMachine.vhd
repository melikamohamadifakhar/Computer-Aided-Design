library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity BinaryMultipleOf3 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        binary_in : in std_logic_vector(4 downto 0);
        is_multiple_of_3 : out std_logic
    );
end BinaryMultipleOf3;

architecture Behavioral of BinaryMultipleOf3 is
	type state_type is (S0, S1, S2);
    signal state : state_type := S0;
begin
    process (clk, rst)
    begin
        if (rst = '1') then
            state <= s0;
        elsif (rising_edge(clk)) then
            for i in 0 to binary_in'length-1 loop
                case state is
                    when s0 =>
                        if (binary_in(i) = '1') then
                            state <= s1;
                        end if;
                    when s1 =>
                        if (binary_in(i) = '0') then
                            state <= s2;
                        else
                            state <= s0;
                        end if;
                    when s2 =>
                        if (binary_in(i) = '0') then
                            state <= s1;
                        end if;
                end case;
            end loop;

            if (state = s0) then
                is_multiple_of_3 <= '1';
            else
                is_multiple_of_3 <= '0';
            end if;
        end if;
    end process;
end Behavioral;
