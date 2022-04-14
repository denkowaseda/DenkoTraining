library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity testbench_adder8 is
end testbench_adder8;

architecture sim of testbench_adder8 is 

constant t : time := 100 ns;

component adder8
port (
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  s : out std_logic_vector(8 downto 0);
  co : out std_logic
  );
end component;

signal co : std_logic;
signal a, b : std_logic_vector(7 downto 0);
signal s : std_logic_vector(8 downto 0);
begin 
  u1 : adder8 port map(
  a => a,
  b => b,
  s => s,
  co => co
  );
  process
  begin
    for i in 0 to 255 loop
	   for j in 0 to 255 loop
		  a <= conv_std_logic_vector(i, 8);
        b <= conv_std_logic_vector(j,8);
        wait for t;
      end loop;
    end loop;
  end process;

--  process
--  begin
--    for i in 239 to 255 loop
--      for j in 239 to 255 loop
--        a <= conv_std_logic_vector(i, 8);
--        b <= conv_std_logic_vector(j, 8);
--        wait for t;
--      end loop;
--    end loop;
--  end process;
end sim;

configuration adder8_test of testbench_adder8 is
  for sim
  end for;
end adder8_test;