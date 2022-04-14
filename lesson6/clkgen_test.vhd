library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_clkgen is
end testbench_clkgen;

architecture sim of testbench_clkgen is 

constant t : time := 100 ns;

component clkgen
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : in std_logic;
blink_on : out std_logic
);
end component;

signal reset, clock, clk_msec : std_logic;
signal blink_on : std_logic;

begin 
  u1 : clkgen port map(
  reset => reset,
  clock => clock,
  clk_msec => clk_msec,
  blink_on => blink_on
  );
  process
  begin
    clock <= '0';
    wait for t;
	
    clock <= '1';
    wait for t;
  end process;

  process
   begin
    clk_msec <= '0';
    wait for t+1 ns;
    clk_msec <= '1';
    wait for t*2;

    clk_msec <= '0';
    wait for t*5 -1 ns;
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

configuration clkgen_test of testbench_clkgen is
  for sim
  end for;
end clkgen_test;