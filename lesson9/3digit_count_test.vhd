library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_seven_seg_top is
end testbench_seven_seg_top;

architecture sim of testbench_seven_seg_top is 

constant t : time := 12.5 ns;

component seven_seg_top
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
end component;

signal reset, clk40m : std_logic;
signal led : std_logic;
signal led8 : std_logic_vector(7 downto 0);
signal seg_a,seg_b,seg_c,seg_d : std_logic;
signal seg_e,seg_f,seg_g,seg_dot : std_logic;
signal sel0,sel1,sel2 : std_logic;

begin 
  u1 : seven_seg_top port map(
  reset => reset,
  clk40m => clk40m,
  led => led,
  led8 => led8,
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
  sel2 => sel2
  );
  process
  begin
    clk40m <= '0';
    wait for t;
	
    clk40m <= '1';
    wait for t;
  end process;

  process
  begin
    reset <= '0';
    wait for 25 ns;
	
    reset <= '1';
    wait for t*2;
	
   wait;
  end process;
end sim;

configuration seven_seg_top_test of testbench_seven_seg_top is
  for sim
  end for;
end seven_seg_top_test;