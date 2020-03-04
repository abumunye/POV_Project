library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity led_control is
    Port (
        clk : in STD_LOGIC;
        reset : in STD_LOGIC;
        i_data_to_send : in STD_LOGIC_VECTOR(7 downto 0);
        o_spi_clk : out STD_LOGIC;
        o_spi_data : out STD_LOGIC
    );
end led_control;

architecture Behavioral of led_control is

    component clock_divider is generic (divider: integer);
       Port( 
            clk: in std_logic;
            o_clk: out std_logic
        );
    end component;

    signal s_spi_clk : STD_LOGIC := '0';
begin

    clock_divider_inst : clock_divider 
    GENERIC MAP(
        divider => 10000000
    )
    PORT MAP(
        clk => clk,
        o_clk => s_spi_clk
    );
    

    spi_transfer : process (clk, reset)
    begin
        if reset = '1' then
        -- reset
        elsif rising_edge(clk) then
            if rising_edge(s_spi_clk) then
                if i_data_to_send(
            end if;
        end if;
    end process;


end Behavioral;
