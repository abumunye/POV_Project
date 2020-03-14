library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Top_Level_TB is
end Top_Level_TB;

architecture Behavioral of Top_Level_TB is

    signal r_Clk : std_logic := '0';
    signal r_Rst_H : std_logic := '0';
    signal r_SPI_Clk : std_logic := '0';
    signal r_SPI_CS : std_logic := '0';
    signal r_SPI_MISO : std_logic := '0';
    
    signal w_SPI_MOSI : std_logic;
    signal w_SPI_Clk : std_logic;
    
    procedure RecieveByte(
        data : in std_logic_vector;
        signal cs : out std_logic;
        signal o_clk : out  std_logic;
        signal o_miso : out std_logic
    ) is
    begin
    wait until rising_edge(r_Clk);
    cs <= '1';
    wait for 1000ns;
    for I in 0 to 7 loop
        wait until rising_edge(r_Clk);
        o_miso <= data(I);
        o_clk <= '1';
        wait for 500ns;
        o_miso <= '0';
        o_clk <= '0';
        wait for 500ns;
    end loop;
    cs <= '0';
    end procedure;

begin

    r_Clk <= not r_Clk after 83ns;

    UUT : entity work.Top_Level 
    port map(
        i_Clk => r_Clk,
        i_Rst_H => r_Rst_H,
        
        i_SPI_CS => r_SPI_CS,
        i_SPI_Clk => r_SPI_Clk,
        i_SPI_MISO => r_SPI_MISO,
        
        o_SPI_Clk => w_SPI_Clk,
        o_SPI_MOSI => w_SPI_MOSI
    ); 

    Testing : process
    begin
        r_Rst_H <= '1';
        wait for 100ns;
        r_Rst_H <= '0';
        wait for 100ns;
        
         RecieveByte(x"01", r_SPI_CS ,r_SPI_Clk, r_SPI_MISO);
         
--        wait for 1000ns;
        
--        RecieveByte(x"FF", r_SPI_CS ,r_SPI_Clk, r_SPI_MISO);
        
--        wait for 1000ns;
        
--        RecieveByte(x"F0", r_SPI_CS ,r_SPI_Clk, r_SPI_MISO);
--        wait for 1000ns;
        
--        RecieveByte(x"00", r_SPI_CS ,r_SPI_Clk, r_SPI_MISO);
        
--        wait for 1000ns;
        WAIT FOR 10000NS;   
        assert false report "Test Complete" severity failure;
    wait;
    end process;

end Behavioral;
