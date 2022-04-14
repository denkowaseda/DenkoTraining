library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_circular is
end testbench_circular;

architecture sim of testbench_circular is 

constant t : time := 100 ns;

component circular
port(
reset : in std_logic;
clock : in std_logic;
en : in std_logic;
sel : out std_logic_vector(2 downto 0)
);
end component;

signal reset, clock, en : std_logic;
signal sel : std_logic_vector(2 downto 0);

begin 
  u1 : circular port map(
  reset => reset,
  clock => clock,
  en => en,
  sel =>sel
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
    en <= '0';
    wait for t+1 ns;
    en <= '1';
    wait for t*2;

    en <= '0';
    wait for t*5 -1 ns;
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

CONFIGURATION circular_test of testbench_circular IS
  for sim
  end for;
end circular_test;