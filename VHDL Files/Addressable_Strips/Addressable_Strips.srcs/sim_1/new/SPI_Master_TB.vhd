library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Master_TB is
end SPI_Master_TB;

architecture Behavioral of SPI_Master_TB is

begin

UUT : entity work.SPI_Master 
generic map(
    g_SPI_CLK => '1';
)
port map(

);

end Behavioral;
