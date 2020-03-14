library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CLK_Divider_TB is
end CLK_Divider_TB;

architecture Behavioral of CLK_Divider_TB is

    constant g_Divider : integer := 10;
    
    signal r_Clk : std_logic := '0';
    signal r_Rst_H : std_logic := '1';
    
    signal w_Clk : std_logic;

begin

    UUT : entity work.CLK_Divider 
        generic map(
            g_Divider => g_Divider
        )
        port map(
            i_Clk => r_Clk,
            i_Rst_H => r_Rst_h,
            o_Clk => w_Clk
        );  
    
    r_Clk <= not(r_Clk) after 10ns;
    
    Testing : process is 
    begin
    
        wait for 100 ns;
        r_Rst_H <= '1';
        wait for 100 ns;
        r_Rst_H <= '0';
    
        wait;
    end process;
    
end Behavioral;
