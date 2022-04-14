library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity sparkling_top is
port(
reset : in std_logic;
clk40m : in std_logic;
led : out std_logic;
led8 : out std_logic_vector(7 downto 0)
);
end sparkling_top;

architecture rtl of sparkling_top IS

component prescaler
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : out std_logic
);
end component;

component clkgen
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : in std_logic;
blink_on : out std_logic;
clk_sec : out std_logic
);
end component;

component sparkling
port(
reset : in std_logic;
clock : in std_logic;
clk_sec : in std_logic;
led : out std_logic_vector(7 downto 0)
);
end component;


signal clk_msec, clk_sec : std_logic;

begin

u1 : prescaler port map(reset => reset, clock => clk40m, clk_msec => clk_msec);
u2 : clkgen port map(reset => reset, clock => clk40m, clk_msec => clk_msec, blink_on => led, clk_sec => clk_sec);
u3 : sparkling port map(reset => reset, clock => clk40m, clk_sec => clk_sec, led => led8);

end RTL;