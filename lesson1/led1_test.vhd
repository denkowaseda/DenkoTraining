library ieee;
use ieee.std_logic_1164.all;
use WORK.all;

entity testbench is
end testbench;

architecture sim of testbench is 

constant t : time := 100 ns;

signal clk40m, PB : std_logic;
signal LED, dummy : std_logic;

component led1
port (
  clk40m : std_logic;
  PB : in std_logic;
  LED : out std_logic;
  dummy : out std_logic
  );
end component;

begin 
  u1 : led1 port map (clk40m => clk40m, PB => PB, 
  LED => LED, dummy => dummy);
  process begin
    clk40m <= '1';
		
    PB <= '1';
    wait for t *1;
    PB <= '0';
    wait for t * 5;
    PB <= '0';
    wait for t * 3;
    PB <= '1';
    wait;
  end process;
		
end sim;

CONFIGURATION led1_test of testbench IS
  for sim
  end for;
end led1_test;