library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity testbench_bin2bcd is
end testbench_bin2bcd;
architecture sim of testbench_bin2bcd is 

constant t : time := 100 ns;

component bin2bcd
port(
  ans : in std_logic_vector(7 downto 0);
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end component;

signal ans : std_logic_vector(7 downto 0);
signal digit1, digit2, digit3 : std_logic_vector(3 downto 0);

begin 
  u1 : bin2bcd port map(
  ans => ans,
  digit1 => digit1,
  digit2 => digit2,
  digit3 => digit3  
  );

  process
  begin
    ans <= "11011111"; -- 223d

    wait for 100 ns;
    ans <= "00001111"; -- 15d

    wait for 100 ns;
    ans <= "00001101"; -- 13d

    wait;
  end process;
end sim;

configuration bin2bcd_test of testbench_bin2bcd is
  for sim
  end for;
end bin2bcd_test;