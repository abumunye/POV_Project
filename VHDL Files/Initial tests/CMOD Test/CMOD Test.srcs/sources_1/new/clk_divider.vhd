-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Author: Abubakar Munye
-------------------------------------------------------------------------------------------------------------------------------------------------------
-- Purpose: The nexys 4 comes with a 100mhz which is too fast for some  things so a clock divider is needed
--          this clock divider counts until an amount then toggles the clock the 
--          the amount the clock divider counts depends on what the generic integer is set when doing port mapping 
-------------------------------------------------------------------------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
  
entity clock_divider is generic (divider: integer);
   Port( 
        clk: in std_logic;
        o_clk: out std_logic
    );
end clock_divider;
  
architecture bhv of clock_divider is
      
    signal count: integer := divider;
    signal tmp : std_logic := '0';
      
begin
------------------------------------------------------------------------------------------------
-- frequency divider counter: counts to divider then toggles tmp.                         
------------------------------------------------------------------------------------------------    
    process(clk)
    begin
        if(clk'event and clk='1') then
            count <=count+1;
            if (count = divider) then
                tmp <= NOT tmp;
                count <= 1;
            end if;
        end if;
        o_clk <= tmp;
    end process;
  
end bhv;
