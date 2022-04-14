library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_blink_top is
end testbench_blink_top;

architecture sim of testbench_blink_top is 

constant t : time := 12.5 ns;

component blink_top
port(
reset : in std_logic;
clk40m : in std_logic;
led : out std_logic
);
end component;

signal reset, clk40m : std_logic;
signal led : std_logic;

begin 
  blink : blink_top port map(
  reset => reset,
  clk40m => clk40m,
  led => led
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

configuration blink_top_test of testbench_blink_top is
  for sim
  end for;
end blink_top_test;