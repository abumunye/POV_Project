

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity top_level is
    Port (
        clk : in STD_LOGIC;
        o_led : out STD_LOGIC;
        o_pin : out STD_LOGIC
    );
end top_level;

architecture Behavioral of top_level is

    component clk_wiz_0
        Port
        (
            clk_out1          : out    std_logic;
            clk_in1           : in     std_logic
        );
    end component;

    component clock_divider is generic (divider: integer);
        Port( 
            clk: in std_logic;
            o_clk: out std_logic
        );
    end component;

    signal clk_100mhz : STD_LOGIC;
    signal clk_1hz : STD_LOGIC;
begin

    o_pin <= '1';
    o_led <= clk_1hz;
    
    one_hz_clk_divider : clock_divider 
    generic map ( 
        divider => 50000000
    )
    port map(
        clk => clk_100mhz,
        o_clk => clk_1hz
    );

    your_instance_name : clk_wiz_0 
    port map ( 
        clk_out1 => clk_100mhz,
        clk_in1 => clk
    );

end Behavioral;
