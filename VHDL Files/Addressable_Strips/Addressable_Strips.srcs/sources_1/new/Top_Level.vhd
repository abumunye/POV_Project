
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level is
    port ( 
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;
        o_Pin : out std_logic;
        o_SPI_Clk : out std_logic;
        o_SPI_MOSI : out std_logic
    );
end Top_Level;

architecture Behavioral of Top_Level is

begin

    SPI : entity work.LED_Strip_Control 
    generic map(
        g_NUMBER_OF_LEDS => 72
    )
    port map(
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        o_SPI_Clk => o_SPI_Clk,
        o_SPI_MOSI => o_SPI_MOSI
    );

end Behavioral;
