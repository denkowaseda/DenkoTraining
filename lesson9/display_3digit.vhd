library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity display_3digit is
  port (
  reset : in std_logic;
  clk40m : in std_logic;
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

architecture rtl of display_3digit is 

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

--component seven_seg
--port(
--  din : in std_logic_vector( 3 downto 0);
--  dout : out std_logic_vector( 7 downto 0)
--);
--end component;

component counter_3digit
port(
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end component;

component dout_mux
port(
  sel : in std_logic_vector(2 downto 0);
  din1, din2,din3 : in std_logic_vector(3 downto 0);
  dout : out std_logic_vector(7 downto 0)
);
end component;

signal clk_msec, clk_sec : std_logic;
signal sel : std_logic_vector(2 downto 0);
signal digit1, digit2, digit3 : std_logic_vector(3 downto 0);
signal dout, dout1, dout2, dout3 : std_logic_vector(7 downto 0);

begin
  u1 : prescaler port map(reset => reset, clock => clk40m, clk_msec => clk_msec);
  u2 : clkgen port map(reset => reset, clock => clk40m, clk_msec => clk_msec, blink_on => led, clk_sec => clk_sec);
  u3 : counter_3digit port map(reset => reset, clock => clk40m, en => clk_sec, digit1 => digit1, digit2 => digit2, digit3 => digit3);
  u4 : dout_mux port map(sel => sel, din1 =>digit1, din2 => digit2, din3 => digit3, dout => dout);
--  u4 : seven_seg port map(din => digit1, dout => dout1);
--  u5 : seven_seg port map(din => digit2, dout => dout2);
--  u6 : seven_seg port map(din => digit3, dout => dout3);
  u5 : circular port map(reset => reset, clock => clk40m, en => clk_msec, sel => sel);

--  process(sel, dout1, dout2, dout3)
--  begin
--    case sel is
--      when "011" => dout <= dout3;
--      when "101" => dout <= dout2;
--      when "110" => dout <= dout1;
--      when others => dout <= "11111111";
--    end case;
--  end process;

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