------------------------------------------------------------------------------/
-- Description: Clock Divider that takes a high frequency input clock 
--              generates a slower input frequency.
--
-- Generics:    g_Divider is the amount that is counted before toggling clock.
--              Equation is g_Divider = ((input frequency/output frequency)/2) - 1
--              e.g. input frequncy is 100Mhz desired output frequency is 1Hz
--              ((100,000,000/1)/2) - 1 = 49999999
------------------------------------------------------------------------------/
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;  

entity CLK_Divider is 
    generic (
        g_Divider: integer
    );
   port( 
        -- Clock/Data Signals
        i_Clk: in std_logic;
        i_Rst_H : in std_logic;
        
        -- Output Clock
        o_Clk: out std_logic
    );
end CLK_Divider;
  
architecture RTL of CLK_Divider is
      
    signal r_Clock_Counter: integer := g_Divider;
    signal r_Clk_Toggle : std_logic := '0';
      
begin
    -- Purpose : Lowers the input clock frequency to generate a slower output clock
    process(i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
            r_Clock_Counter <= 0;
            r_Clk_Toggle <= '0';
        elsif rising_edge(i_Clk) then
            r_Clock_Counter <= r_Clock_Counter + 1;
            if (r_Clock_Counter = g_Divider) then
                r_Clk_Toggle <= NOT r_Clk_Toggle;
                r_Clock_Counter <= 1;
            end if;
        end if;
    end process;
  
    o_Clk <= r_Clk_Toggle;
    
end architecture RTL;
