library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_dout_mux is
end testbench_dout_mux;

architecture sim of testbench_dout_mux is 

component dout_mux
port(
  sel : in std_logic_vector(2 downto 0);
  din1, din2,din3 : in std_logic_vector(3 downto 0);
  dout : out std_logic_vector(7 downto 0)
);
end component;

signal sel : std_logic_vector(2 downto 0);
signal din1 : std_logic_vector(3 downto 0) := "0000";
signal din2 : std_logic_vector(3 downto 0) := "0010";
signal din3 : std_logic_vector(3 downto 0) := "0100";
signal dout : std_logic_vector(7 downto 0);

begin 
  u1 : dout_mux port map(sel => sel, din1 => din1, din2 => din2, din3 => din3, dout => dout);

  process
  begin
    for i in 0 to 15 loop
	   wait for 100 ns;
		din1 <= din1 + 1;
    end loop;
  end process;

  process
  begin
    for i in 0 to 15 loop
	   wait for 100 ns;
		din2 <= din2 + 1;
    end loop;
  end process;

  process
  begin
    for i in 0 to 15 loop
	   wait for 100 ns;
		din3 <= din3 + 1;
    end loop;
  end process;

  process
  begin
    for i in 0 to 15 loop
      sel <= "110";
      wait for 100 ns;
      sel <= "101";
      wait for 100 ns;
      sel <= "011";
      wait for 100 ns;
    end loop;
  end process;	 
end sim;

configuration dout_mux_test of testbench_dout_mux is
  for sim
  end for;
end dout_mux_test;