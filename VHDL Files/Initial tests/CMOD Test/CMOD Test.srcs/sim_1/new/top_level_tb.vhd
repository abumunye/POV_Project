
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity top_level_tb is
end;

architecture bench of top_level_tb is

  component top_level
      Port (
          clk : in STD_LOGIC;
          o_led : out STD_LOGIC
      );
  end component;

  signal clk: STD_LOGIC;
  signal o_led: STD_LOGIC ;
  
  constant clock_period: time := 83 ns;
  signal stop_the_clock: boolean;
begin

  uut: top_level port map ( clk   => clk,
                            o_led => o_led );

    stimulus: process
        begin
        
        -- Put initialisation code here
        
        
        -- Put test bench stimulus code here
        
        wait;
    end process;
    
    
    clocking: process
        begin
            while not stop_the_clock loop
                clk <= '0', '1' after clock_period / 2;
                wait for clock_period;
            end loop;
        wait;
    end process;

end;