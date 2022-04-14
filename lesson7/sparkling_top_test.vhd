library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_sparkling_top is
end testbench_sparkling_top;

architecture sim of testbench_sparkling_top is 

constant t : time := 12.5 ns;

component sparkling_top
port(
  reset : in std_logic;
  clk40m : in std_logic;
  led : out std_logic;
  led8 : out std_logic_vector(7 downto 0)
  );
end component;

signal reset, clk40m : std_logic;
signal led : std_logic;
signal led8 : std_logic_vector(7 downto 0);
begin 

  u1 : sparkling_top port map(reset => reset, clk40m => clk40m, led => led, led8 => led8);

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

configuration sparkling_top_test of testbench_sparkling_top is
  for sim
  end for;
end sparkling_top_test;