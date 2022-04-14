library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_waveforms is
end testbench_waveforms;

architecture sim of testbench_waveforms is 

constant t : time	:= 15.625 us;

component waveforms
port (
clock : in std_logic;
reset : in std_logic;
en : in std_logic;
daout : out std_logic_vector(11 downto 0));
end component;

signal clock, reset, en : std_logic;
signal daout : std_logic_vector(11 downto 0);

begin 
  u1 : waveforms port map(
  clock => clock,
  reset => reset,
  en => en,
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
    reset <= '0'; en <= '1';
    wait for 25 us;
		
    reset <= '1';
    wait for t*20;
		
    wait;
  end process;
end sim;

CONFIGURATION waveforms_test of testbench_waveforms IS
  for sim
  end for;
end waveforms_test;