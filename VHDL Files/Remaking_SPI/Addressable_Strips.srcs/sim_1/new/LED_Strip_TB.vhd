library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED_Strip_TB is
end LED_Strip_TB;

architecture Behavioral of LED_Strip_TB is

    signal r_Clk : std_logic := '0';
    signal r_Rst_H : std_logic := '0';
    signal w_SPI_Clk : std_logic;
    signal w_SPI_MOSI : std_logic;

begin

    r_Clk <= not r_Clk after 5ns;

    UUT : entity work.LED_Strip_Control 
    generic map(
        g_NUMBER_OF_LEDs => 72
    )
    port map(
        i_Clk => r_Clk,
        i_Rst_H => r_Rst_H,
        o_SPI_Clk => w_SPI_Clk,
        o_SPI_MOSI => w_SPI_MOSI
    );
    
    Testing : process is
    begin
        wait for 100ns;
        r_Rst_H <= '1';
        wait for 100ns;
        r_RST_H <= '0';

        wait;
    end process;


end Behavioral;
