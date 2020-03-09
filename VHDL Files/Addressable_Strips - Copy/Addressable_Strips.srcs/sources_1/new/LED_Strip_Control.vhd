library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity LED_Strip_Control is
    generic(
        g_NUMBER_OF_LEDS : integer := 72
    );
    port (
        i_Clk : in std_logic;
        i_Rst_H : in std_logic;
        o_SPI_Clk : out std_logic;
        o_SPI_MOSI : out std_logic
     );
end LED_Strip_Control;
architecture Behavioral of LED_Strip_Control is
    signal r_TX_Byte : std_logic_vector(7 downto 0);  
    signal r_TX_DV : std_logic;
    signal w_TX_Ready : std_logic;
    
    type t_SM_SPI IS (START_FRAME,PIXEL_RGB,END_FRAME);
    signal r_STATE : t_SM_SPI;
    
    type t_SM_LED IS (GLOBAL,BLUE,GREEN,RED);
    signal r_LED_STATE : t_SM_LED;
    
    signal r_TX_Count : integer range 0 to 100;
begin

    spi : entity work.SPI_Master
    generic map (
        g_SPI_CLK => 1    
    )
    port map (
        i_Clk => i_Clk,
        i_Rst_H => i_Rst_H,
        i_TX_Byte => r_TX_Byte,
        i_TX_DV => r_TX_DV,
        o_TX_Ready => w_TX_Ready,
        o_SPI_Clk => o_SPI_Clk,
        o_SPI_MOSI => o_SPI_MOSI
    );
    
    --Purpose: This is the fsm for sending data to the RGB Strip. The spi communication
    --         requires that the first four bytes sent(the start frame) are 0x00 then the
    --         pixel data is sent and finally the end frame is 4 bytes of 0xFF
    Strip_FSM : process (i_Clk, i_Rst_H)
    begin
        if i_Rst_H = '1' then
            r_STATE <= START_FRAME;
            r_TX_DV <= '0';
            r_TX_Count <= 0;
            r_LED_STATE <= GLOBAL;
        elsif rising_edge(i_Clk) then
            case r_STATE is
                when START_FRAME =>
                    r_TX_DV <= '0';
                    if r_TX_Count < 4 then -- Send 4 bytes for first frame
                        if w_TX_Ready = '1' then
                            r_TX_Byte <= (others => '0'); -- send 0x00
                            r_TX_DV <= '1'; -- Pulse DV
                            r_TX_Count <= r_TX_Count + 1;
                        end if;
                    else -- After sending 4 bytes
                        r_STATE <= PIXEL_RGB;
                    end if;
                when PIXEL_RGB =>
                    r_TX_DV <= '0';
                    if r_TX_Count < (g_NUMBER_OF_LEDs + 4) then
                        if w_TX_Ready ='1' then
                            case r_LED_STATE is
                                when GLOBAL =>
                                    r_TX_Byte <= (others => '1'); -- send 0x00
                                    r_LED_STATE <= BLUE;   
                                when BLUE =>
                                    r_TX_Byte <= (others => '0');
                                    r_LED_STATE <= GREEN;
                                when GREEN =>
                                    r_TX_Byte <= (others => '0');
                                    r_LED_STATE <= RED;
                                when RED =>
                                    r_TX_Byte <= (others => '1');   
                                    r_LED_STATE <= GLOBAL;
                                    r_TX_Count <= r_TX_Count + 1;
                            end case;
                            r_TX_DV <= '1';
                        end if;    
                    else
                        r_STATE <= END_FRAME;
                    end if;
                when END_FRAME =>
                    r_TX_DV <= '0';
                    if r_TX_Count < (g_NUMBER_OF_LEDs + 8) then -- Send 4 bytes for last frame
                        if w_TX_Ready = '1' then
                            r_TX_Byte <= (others => '1'); -- send 0xFF
                            r_TX_DV <= '1'; -- Pulse DV
                            r_TX_Count <= r_TX_Count + 1;
                        end if;
                    else -- After sending 4 bytes
                        r_STATE <= START_FRAME;
                        r_TX_Count <= 0;
                        
                    end if;
                end case;
        end if;
    end process;    

end Behavioral;
