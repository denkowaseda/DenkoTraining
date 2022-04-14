library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity digital_counter is
  port (
  reset : in std_logic;
  clk40m : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
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
  led : out stD_logic
  );
end;

architecture rtl of digital_counter is 

component display_3digit
  port (
  reset : in std_logic;
  clk40m : in std_logic;
  cen : in std_logic; -- added for lesson10
  clk_mso : out std_logic; -- added for lesson10
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
  led : out stD_logic
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

signal clk_msec, clk_sec : std_logic;
signal swo, detOut : std_logic_vector(3 downto 0);

begin
  u1 : display_3digit port map(
       reset => reset,
       clk40m => clk40m,
       cen => detOut(3),
       clk_mso => clk_msec,
       seg_a => seg_a,
       seg_b => seg_b,
       seg_c => seg_c,
       seg_d => seg_d,
       seg_e => seg_e,
       seg_f => seg_f,
       seg_g => seg_g,
       seg_dot => seg_dot,
       sel0 => sel0,
       sel1 => sel1,
       sel2 => sel2,
       led => led);
  u2 : chatter port map(reset => reset, clock => clk40m, en => clk_msec, sw => swIn, swo => swo);
  u3 : detEdge port map(reset => reset, clock => clk40m, swIn => swo, detOut => detOut);

end rtl;