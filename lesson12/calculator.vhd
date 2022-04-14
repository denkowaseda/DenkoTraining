library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity calculator is
port (
  clk40m : in std_logic;
  reset : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
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
  sel2 : out std_logic;
  led : out std_logic
  );
end;

architecture rtl of calculator is 

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

component circular
port(
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  sel : out std_logic_vector(2 downto 0)
  );
end component;

component dout_mux
port(
  sel : in std_logic_vector(2 downto 0);
  din1, din2,din3 : in std_logic_vector(3 downto 0);
  dout : out std_logic_vector(7 downto 0)
);
end component;

component chatter
port(
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  sw : in std_logic_vector(3 downto 0);
  swo : out std_logic_vector(3 downto 0)
  );
end component;

component detEdge
port(
  reset : in std_logic;
  clock : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
  detOut : out std_logic_vector(3 downto 0)
  );
end component;

component adder8
port (
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  s : out std_logic_vector(7 downto 0);
  co : out std_logic
  );
end component;

component mul4
port (
  a, b: in std_logic_vector(3 downto 0);
  res: out std_logic_vector(7 downto 0)
);
end component;

component bin2bcd
port(
  ans : in std_logic_vector(7 downto 0);
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end component;

--component result
--port(
--  reset : in std_logic;
--  clock : in std_logic;
--  add : in std_logic;
--  multi : in std_logic;
--  clear : in std_logic;
--  s : in std_logic_vector(7 downto 0);
--  m : in std_logic_vector(7 downto 0);
--  res : out std_logic_vector( 7 downto 0)
--  );
--end component;

component calc_state
port(
  reset : in std_logic;
  clock : in std_logic;
  add : in std_logic;
  multi : in std_logic;
  clear : in std_logic;
  disp : in std_logic;
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  s : in std_logic_vector(7 downto 0);
  m : in std_logic_vector(7 downto 0);
  res : out std_logic_vector( 7 downto 0)
  );
end component;

signal clk_msec, clk_sec, co : std_logic;
signal sel : std_logic_vector(2 downto 0);
signal swo, detOut : std_logic_vector(3 downto 0);
signal digit1, digit2, digit3 : std_logic_vector(3 downto 0);
signal dout, m, s, res : std_logic_vector(7 downto 0);

begin 
  u1 : prescaler port map(reset => reset, clock => clk40m, clk_msec => clk_msec);
  u2 : clkgen port map(reset => reset, clock => clk40m, clk_msec => clk_msec, blink_on => led, clk_sec => clk_sec);
  u3 : dout_mux port map(sel => sel, din1 =>digit1, din2 => digit2, din3 => digit3, dout => dout);
  u4 : circular port map(reset => reset, clock => clk40m, en => clk_msec, sel => sel);
  u5 : chatter port map(reset => reset, clock => clk40m, en => clk_msec, sw => swIn, swo => swo);
  u6 : detEdge port map(reset => reset, clock => clk40m, swIn => swo, detOut => detOut);
  u7 : adder8 port map(a =>a, b => b, s => s, co => co);
  u8 : mul4 port map(a => a(3 downto 0), b => b(3 downto 0), res => m);
  u9 : calc_state port map(reset => reset, clock => clk40m, add => detOut(3), multi => detOut(2), clear => detOut(1),
  disp => detOut(0), a => a, b=> b, s => s, m => m, res => res);
  u10 : bin2bcd port map(ans => res, digit1 => digit1, digit2 => digit2, digit3 => digit3);

  seg_a <= dout(7);
  seg_b <= dout(6);
  seg_c <= dout(5);
  seg_d <= dout(4);
  seg_e <= dout(3);
  seg_f <= dout(2);
  seg_g <= dout(1);
  seg_dot <= dout(0);
  sel0 <= sel(0);
  sel1 <= sel(1);
  sel2 <= sel(2);
  
end rtl;