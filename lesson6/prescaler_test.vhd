library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench is
end testbench;

architecture sim of testbench is 

constant t : time := 100 ns;

component prescaler
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : out std_logic
);
end component;

signal reset, clock : std_logic;
signal clk_msec : std_logic;

begin 
  u1 : prescaler port map(
  reset => reset,
  clock => clock,
  clk_msec => clk_msec
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
    reset <= '0';
    wait for 25 ns;
		
    reset <= '1';
    wait for t*2;
		
    wait;

  end process;
end sim;

configuration prescaler_test of testbench is
  for sim
  end for;
end prescaler_test;