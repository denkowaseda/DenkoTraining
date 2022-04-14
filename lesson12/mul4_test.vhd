library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity testbench_mul4 is
end testbench_mul4;

architecture sim of testbench_mul4 is 

constant t : time := 100 ns;

component mul4
port (
  a : in std_logic_vector(3 downto 0);
  b : in std_logic_vector(3 downto 0);
  res : out std_logic_vector(7 downto 0)
  );
end component;

signal a, b : std_logic_vector(3 downto 0);
signal res : std_logic_vector(7 downto 0);
begin 
  u1 : mul4 port map(
  a => a,
  b => b,
  res => res
  );
  process
  begin
    for i in 0 to 15 loop
	   for j in 0 to 15 loop
		  a <= conv_std_logic_vector(i, 4);
        b <= conv_std_logic_vector(j,4);
        wait for t;
      end loop;
    end loop;
  end process;
end sim;

configuration mul4_test of testbench_mul4 is
  for sim
  end for;
end mul4_test;