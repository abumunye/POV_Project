library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity two_wire_spi is 
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        i_data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
        o_spi_clk : out STD_LOGIC;
        o_spi_data : out STD_LOGIC;
        o_ready_for_data : out STD_LOGIC
    );
end two_wire_spi;

architecture Behavioral of two_wire_spi is

    component clock_divider is generic (divider: integer);
       Port( 
            clk: in std_logic;
            o_clk: out std_logic
        );
    end component;

    signal spi_clk : STD_LOGIC := '0';
    signal new_data : BOOLEAN := TRUE;
    signal ready_for_new_data : BOOLEAN := TRUE;
    signal previous_data_sent : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 
begin

    clock_divider_inst : clock_divider 
    GENERIC MAP(
        divider => 1
    )
    PORT MAP(
        clk => clk,
        o_clk => spi_clk
    );

    

    spi_transfer : process (spi_clk, reset)
        variable current_led : integer := 0;
    begin
        if reset = '1' then
        -- reset
        elsif new_data = TRUE then    
            if rising_edge(spi_clk) then
                o_ready_for_data <= '0'; -- not ready for new data
                if i_data_to_send(current_led) = '1' then -- send a 1
                    o_spi_data <= '1';
                else -- send a 0
                    o_spi_data <= '0';
                end if;
                    current_led := current_led + 1;
                if current_led = 8 then
                    current_led := 0;
                    o_ready_for_data <= '1'; -- ready for new data
                end if;
                o_spi_clk <= '1';
            elsif falling_edge(spi_clk) then
                o_spi_clk <= '0';
                o_spi_data <= '0';
            end if;
        end if;
    end process;

end Behavioral;
