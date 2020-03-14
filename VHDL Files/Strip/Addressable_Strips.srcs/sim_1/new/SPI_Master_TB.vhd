library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Master_TB is
end SPI_Master_TB;

    architecture Behavioral of SPI_Master_TB is

    signal r_Rst_H : std_logic := '0';
    signal r_Clk : std_logic := '0';
    
    signal r_TX_Byte : std_logic_vector(7 downto 0) := (others => '0');
    signal r_TX_DV : std_logic := '0';
    
    signal w_TX_Ready : std_logic;
    signal w_SPI_Clk : std_logic;
    signal w_SPI_MOSI : std_logic;
    
    procedure SendSingleByte (
        data : in std_logic_vector(7 downto 0);
        signal o_data : out std_logic_vector(7 downto 0);
        signal o_dv : out std_logic) is
    begin
        wait until rising_edge(r_Clk);
        o_data <= data;
        o_dv <= '1';
        --wait for 20ns;
        wait until rising_edge(r_Clk);
        o_dv <= '0';
        wait until rising_edge(w_TX_Ready);
    end procedure SendSingleByte;
    
begin
    
    r_Clk <= not r_Clk after 5 ns;
    
    UUT : entity work.SPI_Master 
    generic map(
        g_SPI_CLK => 1
    )
    port map(
        i_Rst_H => r_Rst_H,
        i_Clk => r_Clk,
        i_TX_Byte => r_TX_Byte,
        i_TX_DV => r_TX_DV,
        o_TX_Ready => w_TX_Ready,
        o_SPI_Clk => w_SPI_Clk,
        o_SPI_MOSI => w_SPI_MOSI
    );
    
    Testing : process is 
    begin
        wait for 100 ns;
        r_Rst_H <= '1';
        wait for 100 ns;
        r_Rst_H <= '0';
        
        wait for 100ns;
        SendSingleByte(X"C1", r_TX_Byte, r_TX_DV);
        
        SendSingleByte(X"BE", r_TX_Byte, r_TX_DV);
        
        SendSingleByte(X"EF", r_TX_Byte, r_TX_DV);
        
        wait for 1000ns;
        
        SendSingleByte(X"00", r_TX_Byte, r_TX_DV);
        wait;
    end process;

end Behavioral;
