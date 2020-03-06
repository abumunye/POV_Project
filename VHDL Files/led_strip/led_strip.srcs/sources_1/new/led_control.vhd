library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity two_wire_spi is 
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        i_sending_data : in STD_LOGIC;
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
    signal new_data : BOOLEAN := false;
    signal ready_for_new_data : BOOLEAN := TRUE;
    signal previous_data_sent : STD_LOGIC_VECTOR(7 downto 0) := "00000000"; 
    type states IS (waiting_for_data,sending_data);
    signal current_state : states;

begin

    clock_divider_inst : clock_divider 
    GENERIC MAP(
        divider => 1
    )
    PORT MAP(
        clk => clk,
        o_clk => spi_clk
    );

    fsm : process (clk, reset,i_sending_data)
    begin
        if reset = '1' then
            --reset
        elsif rising_edge(clk) then
            case current_state is 
                when waiting_for_data =>
                    if i_sending_data = '1' then
                        new_data <= TRUE;
                        current_state <= sending_data;
                    end if;
                when sending_data =>
                    if ready_for_new_data = TRUE then
                        current_state <= waiting_for_data;
                        new_data <= FALSE;
                    end if;
                when others =>
                
            end case;
        end if;
    end process;

    spi_transfer : process (spi_clk, reset)
        variable current_bit : integer := 0;    
    begin
        if reset = '1' then
        -- reset
        elsif new_data = TRUE then    
            if rising_edge(spi_clk) then
                o_ready_for_data <= '0'; -- not ready for new data
                ready_for_new_data <= FALSE;
                if i_data_to_send(current_bit) = '1' then -- send a 1
                    o_spi_data <= '1';
                else -- send a 0
                    o_spi_data <= '0';
                end if;
                o_spi_clk <= '1';
                current_bit := current_bit + 1;
            elsif falling_edge(spi_clk) then
                o_spi_clk <= '0';
                o_spi_data <= '0';
                if current_bit = 8 then 
                    current_bit := 0;
                    o_ready_for_data <= '1'; -- not ready for new data
                    ready_for_new_data <= TRUE;
                end if;
            end if;
        end if;
    end process;

end Behavioral;
