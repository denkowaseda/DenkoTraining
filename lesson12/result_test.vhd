library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_result is
end testbench_result;

architecture sim of testbench_result is 

constant t : time := 100 ns;

component result
port(
  reset : in std_logic;
  clock : in std_logic;
  add : in std_logic;
  multi : in std_logic;
  clear : in std_logic;
  s : in std_logic_vector(7 downto 0);
  m : in std_logic_vector(7 downto 0);
  res : out std_logic_vector( 7 downto 0)
  );
end component;

signal reset, clock, add, multi, clear : std_logic;
signal m : std_logic_vector(7 downto 0);
signal s, res : std_logic_vector(7 downto 0);

begin 
  u1 : result port map(
  reset => reset,
  clock => clock,
  add => add,
  multi => multi,
  clear => clear,
  s => s,
  m => m,
  res => res
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
    add <= '0';
    multi <= '0';
    clear <= '0';
    s <= "00000000";
    m <= "00000000";
    wait for t*2;
	
    reset <= '1';
    wait for t*2;
	 
    s <= "01010101";
    m <= "00001010";
	 wait for t*2;
	 
	 add <= '1';
    wait for t*2;

    add <= '0';
    wait for t*2;
	 
    add <= '1';
    wait for t*2;
	 
    add <= '0';
	 wait for t*4;
	 
    multi <= '1';
    wait for t*2;

    multi <= '0';
    wait for t*2;

    multi <= '1';	 
    wait for t*2;

    multi <= '0';
    wait for t*4;

    clear <= '1';
    wait for t*2;

    clear <= '0';
	 wait for t*2;
	 
	 add <= '1';
    wait for t*2;

    add <= '0';
    wait for t*2;

    clear <= '1';
    wait for t*2;

    clear <= '0';
	 wait for t*2;

    multi <= '1';
    wait for t*2;

    multi <= '0';
    wait for t*2;

    clear <= '1';
    wait for t*2;

    clear <= '0';
	 wait for t*2;

    wait;
  end process;
end sim;

configuration result_test of testbench_result is
  for sim
  end for;
end result_test;