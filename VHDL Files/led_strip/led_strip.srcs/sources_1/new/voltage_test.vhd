
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity voltage_test is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        led : out STD_LOGIC
    );
end voltage_test;

architecture Behavioral of voltage_test is


begin

led <= '1';

end Behavioral;
