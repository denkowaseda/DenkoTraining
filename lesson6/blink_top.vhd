library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity blink_top is
port(
reset : in std_logic;
clk40m : in std_logic;
led : out std_logic
);
end blink_top;

architecture rtl of blink_top IS

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
blink_on : out std_logic
);
end component;

signal clk_msec : std_logic;

begin

u1 : prescaler port map(reset => reset, clock => clk40m, clk_msec => clk_msec);
u2 : clkgen port map(reset => reset, clock => clk40m, clk_msec => clk_msec, blink_on => led);

end RTL;