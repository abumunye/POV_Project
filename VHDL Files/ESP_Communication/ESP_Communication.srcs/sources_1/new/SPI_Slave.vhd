----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.03.2020 21:28:23
-- Design Name: 
-- Module Name: SPI_Slave - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Slave is
    Port (
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;
        
        i_SPI_CS : in std_logic;
        i_SPI_Clk : in std_logic;
        i_SPI_MISO : in std_logic;
        
        o_Data : out std_logic_vector(7 downto 0);
        o_TX_DV : out std_logic
        );
end SPI_Slave;
    
architecture Behavioral of SPI_Slave is
    signal r_Bit_Count : integer range 0 to 8 := 7;
    signal r_Recieved_Full_Byte : boolean := false;
    signal r_TX_DV : std_logic := '0';
    signal r_Half_Clk : std_logic := '0';
    signal r_TX_Hold_Cnt : integer range 0 to 10 := 0;
begin
--    o_TX_DV <= r_TX_DV;
    
    MOSI : process(i_Rst_H, i_Clk, i_SPI_Clk) 
    begin
        if i_Rst_H = '1' then
            o_Data <= (others => '0');
            r_Bit_Count <= 7;
            o_TX_DV <= '0';
        elsif rising_edge(i_Clk) then
            if r_Bit_Count >= 0 then
                o_TX_DV <= '0';
                if i_SPI_CS = '1' then
    --                o_TX_DV <= '0';
                    if rising_edge(i_SPI_Clk) then
                        o_Data(r_Bit_Count) <=  i_SPI_MISO;
                        r_Bit_Count <= r_Bit_Count - 1;
                    end if;
                end if;
            else
                if r_TX_Hold_Cnt > 3 then
                    r_Bit_Count <= 7; -- reset bit counter;
                    r_TX_Hold_Cnt <= 0;
                end if;
                r_TX_Hold_Cnt <= r_TX_Hold_Cnt + 1;
                o_TX_DV <= '1';
            end if;
        end if;
    end process; 

    Half_Clk : process(i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
            r_Half_Clk <= '0';
        elsif rising_edge(i_Clk) then
            r_Half_Clk <= not r_Half_Clk;
        end if;
    end process;
    
end Behavioral;
