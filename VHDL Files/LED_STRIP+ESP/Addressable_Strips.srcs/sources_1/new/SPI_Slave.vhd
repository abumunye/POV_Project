library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Slave is
  port (
    i_RST_H    : in  std_logic;
    i_Clk      : in  std_logic;
    i_SPI_CLK     : in std_logic;
    i_SPI_CS      : in std_logic;
    i_SPI_MOSI    : in  std_logic;
    o_TX_DV    : out std_logic;
    o_Data     : out std_logic_vector(7 downto 0)
    );
end SPI_Slave;

architecture Behavioral of SPI_Slave is

    signal r_SCLK_latched, r_SCLK_old : std_logic;
    signal r_CS_latched, r_CS_old : std_logic;
    signal r_MOSI_latched: std_logic;
    signal r_Index: natural range 0 to 7;
    signal r_RX_Data : std_logic_vector(7 downto 0);

begin

 --
 -- Sync process
 --

  process(i_Clk, i_RST_H)

 begin
    if (i_RST_H = '1') then
      r_RX_Data <= (others => '0');
      r_Index <= 7;
      r_SCLK_old <= '0';
      r_SCLK_latched <= '0';
      r_CS_old <= '0';
      r_CS_latched <= '0';
      o_TX_DV <= '0';
      r_MOSI_latched <= '0';

    elsif( rising_edge(i_Clk) ) then

      r_SCLK_latched <= i_SPI_CLK;
      r_SCLK_old <= r_SCLK_latched;
      r_CS_latched <= i_SPI_CS;
      r_CS_old <= r_CS_latched;
      o_TX_DV <= '0';
      r_MOSI_latched <= i_SPI_MOSI;

      if (r_CS_old = '0' and r_CS_latched = '1') then
          r_Index <= 7;
      end if;

      if( r_CS_latched = '1' ) then
         if(r_SCLK_old = '0' and r_SCLK_latched = '1') then
            r_RX_Data <= r_RX_Data(6 downto 0) & r_MOSI_latched;
            if(r_Index = 0) then -- cycle ended
               r_Index <= 7;
            else
               r_Index <= r_Index-1;
            end if;
         elsif(r_SCLK_old = '1' and r_SCLK_latched = '0') then
            if( r_Index = 7 ) then
               o_TX_DV <= '1';
            end if;
         end if;
      end if;
     end if;

   end process;

   --
   -- Combinational assignments
   --

   o_Data <= r_RX_Data;

end Behavioral;