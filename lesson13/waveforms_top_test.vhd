library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_waveforms_top is
end testbench_waveforms_top;

architecture sim of testbench_waveforms_top is 

constant t : time	:= 12.5 ns;

component waveforms_top
port (
clock : in std_logic;
reset : in std_logic;
daout : out std_logic_vector(9 downto 0));
end component;

signal clock, reset : std_logic;
signal daout : std_logic_vector(9 downto 0);

begin 
  u1 : waveforms_top port map(
  clock => clock,
  reset => reset,
  daout => daout
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
    wait for t*10;
		
    reset <= '1';
		
    wait;
  end process;
end sim;

CONFIGURATION waveforms_top_test of testbench_waveforms_top IS
  for sim
  end for;
end waveforms_top_test;