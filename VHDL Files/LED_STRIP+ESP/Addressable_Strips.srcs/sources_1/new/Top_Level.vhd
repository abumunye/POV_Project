
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.Vector_Array.all;


entity Top_Level is
    port ( 
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;
        o_SPI_Clk : out std_logic;
        o_SPI_MOSI : out std_logic;
        o_Full_Cycle : out std_logic
    );
end Top_Level;

architecture Behavioral of Top_Level is
component clk_wiz_0
port
 (-- Clock in ports
  -- Clock out ports
  clk_out1          : out    std_logic;
  clk_in1           : in     std_logic
 );
end component;

    signal w_100Mhz_Clk : std_logic;
    signal r_Pixel_Data : t_Vector_Array(0 to 72*3);
begin

your_instance_name : clk_wiz_0
   port map ( 
  -- Clock out ports  
   clk_out1 => w_100Mhz_Clk,
   -- Clock in ports
   clk_in1 => i_Clk
 );

    SPI : entity work.LED_Strip_Control 
    generic map(
        g_NUMBER_OF_LEDS => 72
    )
    port map(
        i_Clk => w_100Mhz_Clk,
        i_Rst_H => i_Rst_H,
        i_Pixel_Data => r_Pixel_Data,
        o_SPI_Clk => o_SPI_Clk,
        o_SPI_MOSI => o_SPI_MOSI,
        o_Full_Cycle => o_Full_Cycle
    );

end Behavioral;
