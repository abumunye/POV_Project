library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Slave_TB is
end SPI_Slave_TB;

architecture Behavioral of SPI_Slave_TB is

    signal r_Clk : std_logic := '0';
    signal r_Rst_H : std_logic := '0';
    signal r_SPI_Clk : std_logic := '0';
    signal r_SPI_CS : std_logic := '0';
    signal r_SPI_MOSI : std_logic := '0';
    
    signal w_TX_DV : std_logic;
    signal w_Data : std_logic_vector(7 downto 0);
    
    procedure RecieveByte(
        data : in std_logic_vector;
        signal cs : out std_logic;
        signal o_clk : out  std_logic;
        signal o_miso : out std_logic
    ) is
    begin
    wait until rising_edge(r_Clk);
    cs <= '1';
    for I in 0 to 7 loop
        wait until rising_edge(r_Clk);
        o_miso <= data(I);
        o_clk <= '1';
        wait for 10ns;
        o_miso <= '0';
        o_clk <= '0';
        wait for 10ns;
    end loop;
    cs <= '0';
    end procedure;
    
    signal i_data : std_logic_vector(7 downto 0);
begin

    r_Clk <= not r_Clk after 5ns; 
    
    UUT : entity work.SPI_Slave
    port map(
        i_Clk => r_Clk,
        i_Rst_H => r_Rst_H,
        i_SPI_CS => r_SPI_CS,
        i_SPI_MOSI => r_SPI_MOSI,
        i_SPI_Clk => r_SPI_Clk,
        o_Data => w_Data,
        o_TX_DV => w_TX_DV
    );
    
    Testing : process
    begin
    
        RecieveByte(x"01", r_SPI_CS ,r_SPI_Clk, r_SPI_MOSI);
         
        wait for 100ns;
        
        RecieveByte(x"FF", r_SPI_CS ,r_SPI_Clk, r_SPI_MOSI);
        
        wait for 100ns;
        
        RecieveByte(x"F0", r_SPI_CS ,r_SPI_Clk, r_SPI_MOSI);
        wait for 100ns;
        
        RecieveByte(x"00", r_SPI_CS ,r_SPI_Clk, r_SPI_MOSI);
    wait;
    end process;    

end Behavioral;
