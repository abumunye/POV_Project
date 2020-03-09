library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SPI_Master is
    generic (
      g_SPI_CLK : integer := 1  
    );
    port ( 
        --Control/data signals
        i_Rst_H : in std_logic;
        i_Clk : in std_logic;
        
        -- TX (MOSI) Signals
        i_TX_Byte   : in std_logic_vector(7 downto 0);   -- Byte to transmit on MOSI
        i_TX_DV     : in std_logic;          -- Data Valid Pulse with i_TX_Byte
        o_TX_Ready  : out std_logic;         -- Transmit Ready for next byte
        
        -- SPI Interface
        o_SPI_Clk  : out std_logic;
        o_SPI_MOSI : out std_logic
    );
end SPI_Master;

architecture Behavioral of SPI_Master is
    signal r_Slow_Clk : std_logic;
    signal r_TX_Byte : std_logic_vector(7 downto 0);
    signal r_TX_DV : std_logic;
    signal r_SPI_Bits : integer range 0 to 8;
    
begin
    
    SPI_Clock_Divider : entity work.CLK_Divider
    generic map(
        g_Divider => g_SPI_CLK
    )
    port map(
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        o_Clk => r_Slow_Clk
    );
    
    --Purpose: transmits the SPI Data
    MOSI_SPI_Transfer : process(i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
            r_SPI_Bits <= 0;
--            o_TX_Ready <= '1'; 
--            o_SPI_Clk <= '0'; 
            o_SPI_MOSI <= '0';
        else
            if i_TX_DV = '1' then
                o_TX_Ready <= '0';
                r_SPI_Bits <= 8;
            elsif r_SPI_Bits > 0 then
                if falling_edge(i_Clk) then
                    o_SPI_Clk <= '0';
                    o_SPI_MOSI <= '0';
                    if r_SPI_Bits = 0 then
                        o_SPI_Clk <= '0'; 
                        o_SPI_MOSI <= '0'; 
                    end if;
                end if;
                if rising_edge(i_Clk) then
                    if r_TX_Byte(r_SPI_Bits - 1) = '1' then
                        o_SPI_MOSI <= '1'; 
                    else
                        o_SPI_MOSI <= '0'; 
                    end if;
                    r_SPI_Bits <= r_SPI_Bits - 1; 
                    o_SPI_Clk <= '1';
                end if;
            elsif falling_edge(i_Clk) then -- if spi bits is 0 and also falling edge
                    o_TX_Ready <= '1';
                o_SPI_Clk <= '0'; 
                o_SPI_MOSI <= '0'; 
            end if;
        end if;
    end process;
    
    -- Purpose: Register i_TX_Byte when Data Valid is pulsed.
    -- Keeps local storage of                byte in case higher level module changes the data
    Byte_Reg : process (i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
            r_TX_Byte <= (others => '0');
            r_TX_DV   <= '0';
        elsif rising_edge(i_clk) then
            r_TX_DV <= i_TX_DV; -- 1 clock cycle delay
            if i_TX_DV = '1' then
                r_TX_Byte <= i_TX_Byte;
            end if;
        end if;
    end process Byte_Reg;
end Behavioral;
