library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_detEdge is
end testbench_detEdge;

architecture sim of testbench_detEdge is 

constant t : time := 100 ns;

component detEdge
port(
  reset : in std_logic;
  clock : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
  detOut : out std_logic_vector(3 downto 0)
  );
end component;

signal reset, clock : std_logic;
signal swIn,detOut : std_logic_vector(3 downto 0);

begin 
  u1 : detEdge port map(
  reset => reset,
  clock => clock,
  swIn => swIn,
  detOut => detOut  
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
    swIn <= "1111";
	 
    wait for t + 1 ns;
	 reset <= '1';
    swIn <= "1110";
	 
    wait for t*10;
    swIn <= "1101";
	 
    wait for t*10;
    swIn <= "1011";
	 
    wait for t*10;
    swIn <= "0111";
	 
    wait for t*10;
    swIn <= "1111";

    wait;
  end process;
end sim;

configuration detEdge_test of testbench_detEdge is
  for sim
  end for;
end detEdge_test;