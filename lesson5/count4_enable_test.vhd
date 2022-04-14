library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench is
end testbench;

architecture sim of testbench is 

constant t : time	:= 100 ns;

component count_enable
port (
reset : in std_logic;
clock : in std_logic;
en : in std_logic;
q : out std_logic_vector(3 downto 0)
);
end component;

signal reset, clock, en : std_logic;
signal q : std_logic_vector(3 downto 0);

begin 
  u1 : count_enable port map(
  reset => reset,
  clock => clock,
  en => en,
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
    en <= '0';
    wait for 25 ns;
		
    reset <= '1';
    wait for t*2;
		
    en <= '1';
    wait for t*10;
		
    en <= '0';
    wait for t*4;
		
    en <= '1';
    wait for t*10;
		
    wait;
  end process;
end sim;

CONFIGURATION count_enable_test of testbench IS
  for sim
  end for;
end count_enable_test;