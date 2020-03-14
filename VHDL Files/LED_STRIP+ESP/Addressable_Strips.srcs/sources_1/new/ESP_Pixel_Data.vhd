
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library work;
use work.Vector_Array.all;

entity ESP_Pixel_Data is
    Port (
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;
        
        i_Recieving_Pixel_Data : in std_logic;
        i_SPI_CS : in std_logic;
        i_SPI_Clk : in std_logic;
        i_SPI_MOSI : in std_logic;
        
        o_Pixel_Data : out t_Vector_Array(0 to 72*3)
    );
end ESP_Pixel_Data;

architecture Behavioral of ESP_Pixel_Data is
    signal r_TX_DV : std_logic := '0';
    signal r_Data : std_logic_vector(7 downto 0) := (others => '0');
begin

    ESP_SPI_Data : entity work.SPI_Slave
    port map(
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        i_SPI_Clk => i_SPI_Clk,
        i_SPI_CS => i_SPI_CS,
        i_SPI_MOSI => i_SPI_MOSI,
        o_Data => r_Data,
        o_TX_DV => r_TX_DV
        );
        
    Store_Pixel_Data : process(i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
        
        elsif rising_edge(i_Clk) then
            
            if i_Recieving_Pixel_Data = '1' then
                
            end if;
        end if;
    end process;

end Behavioral;
