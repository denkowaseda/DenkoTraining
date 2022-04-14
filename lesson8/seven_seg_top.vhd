library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity seven_seg_top is
port(
reset : in std_logic;
clk40m : in std_logic;
led : out std_logic;
led8 : out std_logic_vector(7 downto 0);
seg_a : out std_logic;
seg_b : out std_logic;
seg_c : out std_logic;
seg_d : out std_logic;
seg_e : out std_logic;
seg_f : out std_logic;
seg_g : out std_logic;
seg_dot : out std_logic;
sel0 : out std_logic;
sel1 : out std_logic;
sel2 : out std_logic
);
end seven_seg_top;

architecture rtl of seven_seg_top IS

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

component seven_seg
port(
  din : in std_logic_vector( 3 downto 0);
  dout : out std_logic_vector( 7 downto 0)
);
end component;

component count_enable
  port (
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  q : out std_logic_vector(3 downto 0)
  );
end component;

signal clk_msec, clk_sec : std_logic;
signal din : std_logic_vector(3 downto 0);
signal dout : std_logic_vector(7 downto 0);

begin

u1 : prescaler port map(reset => reset, clock => clk40m, clk_msec => clk_msec);
u2 : clkgen port map(reset => reset, clock => clk40m, clk_msec => clk_msec, blink_on => led, clk_sec => clk_sec);
u3 : sparkling port map(reset => reset, clock => clk40M, clk_sec => clk_sec, led => led8);
u4 : count_enable port map(reset => reset, clock => clk40M, en => clk_sec, q => din);
u5 : seven_seg port map(din => din, dout => dout);

seg_a <= dout(7);
seg_b <= dout(6);
seg_c <= dout(5);
seg_d <= dout(4);
seg_e <= dout(3);
seg_f <= dout(2);
seg_g <= dout(1);

seg_dot <= '1';
sel0 <= '0';
sel1 <= '1';
sel2 <= '1';

end RTL;