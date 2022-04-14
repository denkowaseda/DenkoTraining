library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_addr_counter is
end testbench_addr_counter;

architecture sim of testbench_addr_counter is 

constant t : time := 12.5 ns;

component addr_counter
port(
reset : in std_logic;
clock : in std_logic;
rom_addr : out std_logic_vector(5 downto 0)
);end component;

signal reset, clock : std_logic;
signal rom_addr : std_logic_vector(5 downto 0);

begin 
  u1 : addr_counter port map(
  reset => reset,
  clock => clock,
  rom_addr => rom_addr
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
    wait for t*100;
	 
	 reset <= '1';
	 
    wait;
  end process;
end sim;

configuration addr_counter_test of testbench_addr_counter is
  for sim
  end for;
end addr_counter_test;