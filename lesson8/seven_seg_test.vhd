library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_seven_seg is
end testbench_seven_seg;

architecture sim of testbench_seven_seg is 

component seven_seg
port(
din : in std_logic_vector(3 downto 0);
dout : out std_logic_vector(7 downto 0)
);
end component;

signal din : std_logic_vector(3 downto 0) := "0000";
signal dout : std_logic_vector(7 downto 0);

begin 
  u1 : seven_seg port map(din => din, dout => dout);

  process
  begin
    for i in 0 to 15 loop
	   wait for 100 ns;
		din <= din + 1;
    end loop;
  end process;

end sim;

configuration seven_seg_test of testbench_seven_seg is
  for sim
  end for;
end seven_seg_test;