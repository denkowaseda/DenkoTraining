library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity testbench_div4 is
end testbench_div4;

architecture sim of testbench_div4 is 

constant t : time := 100 ns;

component div4
port (
  a : in std_logic_vector(3 downto 0);
  q : out std_logic_vector(3 downto 0);
  r : out std_logic_vector(3 downto 0)
);
end component;

signal a : std_logic_vector(3 downto 0);
signal q, r : std_logic_vector(3 downto 0);
begin 
  u1 : div4 port map(
  a => a,
  q => q,
  r => r
  );
  process
  begin
    for i in 0 to 15 loop
		a <= conv_std_logic_vector(i, 4);
      wait for t;
    end loop;
  end process;
end sim;

configuration div4_test of testbench_div4 is
  for sim
  end for;
end div4_test;