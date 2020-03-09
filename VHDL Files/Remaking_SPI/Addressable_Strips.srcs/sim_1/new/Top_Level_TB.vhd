library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level_TB is
end Top_Level_TB;

architecture Behavioral of Top_Level_TB is
    signal r_Clk : std_logic := '0';
    signal r_Rst_H : std_logic := '0';
    signal w_SPI_MOSI : std_logic;
    signal w_SPI_Clk : std_logic;
    signal w_Pin : std_logic;
    signal w_Full_Cycle : std_logic;
begin

    r_Clk <= not r_Clk after 83ns;

    UUT : entity work.Top_Level
    port map(
        i_Clk => r_Clk,
        i_Rst_H => r_Rst_H,
        o_SPI_MOSI => w_SPI_MOSI,
        o_SPI_Clk => w_SPI_Clk,
        o_Full_Cycle => w_Full_Cycle
    );
    
    Testing : process is
    begin
        wait for 100ns;
        r_Rst_H <= '1';
        wait for 100ns;
        r_Rst_H <= '0';

        wait;
    end process;

end Behavioral;
