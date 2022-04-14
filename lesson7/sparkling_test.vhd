library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_sparkling is
end testbench_sparkling;

architecture sim of testbench_sparkling is 

constant t : time := 100 ns;

component sparkling
port(
reset : in std_logic;
clock : in std_logic;
clk_sec : in std_logic;
led : out std_logic_vector(7 downto 0)
);
end component;

signal reset, clock, clk_sec : std_logic;
signal led : std_logic_vector(7 downto 0);

begin 
  u1 : sparkling port map(
  reset => reset,
  clock => clock,
  clk_sec => clk_sec,
  led => led
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
    clk_sec <= '0';
    wait for t+1 ns;
    clk_sec <= '1';
    wait for t*2;

    clk_sec <= '0';
    wait for t*5 -1 ns;
  end process;
  
  process
  begin
    reset <= '0';
    wait for 100 ns;
	
    reset <= '1';
    wait for t*2;
	
   wait;
  end process;
end sim;

configuration sparkling_test of testbench_sparkling is
  for sim
  end for;
end sparkling_test;