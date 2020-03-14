library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level is
    port ( 
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;

        i_SPI_CS : in std_logic;
        i_SPI_Clk : in std_logic;
        i_SPI_MISO : in std_logic;
        
        o_SPI_Clk : out std_logic;    
        o_SPI_MOSI : out std_logic;  
        o_TX_DV : out std_logic  
    );
end Top_Level;

architecture Behavioral of Top_Level is

    signal w_Data : std_logic_vector(7 downto 0);
    signal w_TX_DV : std_logic;
    
begin
    o_TX_DV <= '1';
    
    SPI_Read : entity work.SPI_Slave 
    port map(
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        i_SPI_CS => i_SPI_CS,
        i_SPI_Clk => i_SPI_Clk,
        i_SPI_MISO => i_SPI_MISO,
        o_Data => w_Data,
        o_TX_DV => w_TX_DV
    );

    SPI_Write : entity work.SPI_Master
    generic map(
        g_SPI_CLK => 1
    )
    port map(
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        i_TX_Byte => w_Data,
        i_TX_DV => w_TX_DV,
        --o_TX_Ready -- no use for this for now.
        o_SPI_Clk => o_SPI_Clk,
        o_SPI_MOSI => o_SPI_MOSI
    );

end Behavioral;
