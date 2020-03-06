    library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;
    
    entity led_strip_control is
        Port ( 
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            o_spi_data : out STD_LOGIC;
            o_spi_clk : out STD_LOGIC
        );
    end led_strip_control;
    
        architecture Behavioral of led_strip_control is
    
        component two_wire_spi is 
            Port (
                clk : in STD_LOGIC;
                reset : in STD_LOGIC;
                i_sending_data : in STD_LOGIC;
                i_data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
                o_spi_clk : out STD_LOGIC;
                o_spi_data : out STD_LOGIC;
                o_ready_for_data : out STD_LOGIC
            );
        end component;
    
        signal sending_data, ready_for_data : STD_LOGIC;
        signal data : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    begin
    
        spi : two_wire_spi PORT MAP(
            clk => clk,
            reset => reset,
            i_sending_data => sending_data,
            i_data_to_send => data,
            o_spi_clk => o_spi_clk,
            o_spi_data => o_spi_data,
            o_ready_for_data => ready_for_data
        );
    
        
        
        
        
    end Behavioral;
