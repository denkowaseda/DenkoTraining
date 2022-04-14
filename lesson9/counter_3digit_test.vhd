library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_counter_3digit is
end testbench_counter_3digit;

architecture sim of testbench_counter_3digit is 

constant t : time := 12.5 ns;

component counter_3digit
  port (
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end component;

signal reset, clock, en : std_logic;
signal digit1, digit2, digit3 : std_logic_vector(3 downto 0);

begin 
  u1 : counter_3digit port map(
  reset => reset,
  clock => clock,
  en => en,
  digit1 => digit1,
  digit2 => digit2,
  digit3 => digit3
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
    en <= '0';
    wait for t+1 ns;
    en <= '1';
    wait for t*2;

    en <= '0';
    wait for t*5 -1 ns;
  end process; 
  
  process
  begin
    reset <= '0';
    wait for 25 ns;
	
    reset <= '1';
    wait for t*2;
	
   wait;
  end process;
end sim;

configuration counter_3digit_test of testbench_counter_3digit is
  for sim
  end for;
end counter_3digit_test;