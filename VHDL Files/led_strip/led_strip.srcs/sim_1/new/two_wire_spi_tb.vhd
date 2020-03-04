
library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity two_wire_spi_tb is
end;

architecture bench of two_wire_spi_tb is

  component two_wire_spi 
      Port (
          clk : in STD_LOGIC;
          reset : in STD_LOGIC;
          i_data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
          o_spi_clk : out STD_LOGIC;
          o_spi_data : out STD_LOGIC;
          o_ready_for_data : out STD_LOGIC
      );
  end component;

  signal clk: STD_LOGIC;
  signal reset: STD_LOGIC;
  signal i_data_to_send: STD_LOGIC_VECTOR(7 downto 0);
  signal o_spi_clk: STD_LOGIC;
  signal o_spi_data: STD_LOGIC;
  signal o_ready_for_data: STD_LOGIC ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: two_wire_spi port map ( clk              => clk,
                               reset            => reset,
                               i_data_to_send   => i_data_to_send,
                               o_spi_clk        => o_spi_clk,
                               o_spi_data       => o_spi_data,
                               o_ready_for_data => o_ready_for_data );

  stimulus: process
  begin
  
    -- Put initialisation code here

    reset <= '1';
    wait for 5 ns;
    reset <= '0';
    wait for 5 ns;

    -- Put test bench stimulus code here
i_data_to_send <= "11111111";

wait for 1us;

i_data_to_send <= "11110000";

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
  