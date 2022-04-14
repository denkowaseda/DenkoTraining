library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench is
end testbench;

architecture sim of testbench is 

constant t : time:= 100 ns;

component count_decimal
port (
  reset : in std_logic;
  clock : in std_logic;
  q : out std_logic_vector(3 downto 0)
  );
end component;

signal reset, clock : std_logic;
signal q : std_logic_vector(3 downto 0);

begin 
  u1 : count_decimal port map(
    reset => reset,
    clock => clock,
    q => q
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
    wait for t*20;
		
    wait;
  end process;
end sim;

configuration count_decimal_test of testbench is
  for sim
  end for;
end count_decimal_test;