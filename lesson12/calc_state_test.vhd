library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_calc_state is
end testbench_calc_state;

architecture sim of testbench_calc_state is 

constant t : time := 100 ns;

component calc_state
port(
  reset : in std_logic;
  clock : in std_logic;
  add : in std_logic;
  multi : in std_logic;
  clear : in std_logic;
  disp : in std_logic;
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  s : in std_logic_vector(7 downto 0);
  m : in std_logic_vector(7 downto 0);
  res : out std_logic_vector( 7 downto 0)
  );
end component;

signal reset, clock, add, multi, clear, disp : std_logic;
signal m, a, b : std_logic_vector(7 downto 0);
signal s, res : std_logic_vector(7 downto 0);

begin 
  u1 : calc_state port map(
  reset => reset,
  clock => clock,
  add => add,
  multi => multi,
  clear => clear,
  disp => disp,
  a => a,
  b => b,
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
    disp <= '0';
    a <= "00000000";
    b <= "00000000";
    s <= "00000000";
    m <= "00000000";
    wait for t*2;
	
    reset <= '1';
    wait for t*2;
	 
    a <= "11110000";
    b <= "00001111";
    s <= "01010101";
    m <= "00001010";
	 wait for t*2;

    -- s0 to s1	 
    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*2;

    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*4;

    -- s1 to s2
    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*2;

    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*4;

    -- s2 to s3
	 add <= '1';
    wait for t*2;

    add <= '0';
    wait for t*2;
	 
    add <= '1';
    wait for t*2;
	 
    add <= '0';
	 wait for t*4;

    -- s3 to s0
    clear <= '1';
    wait for t*2;

    clear <= '0';
    wait for t*2;

    clear <= '1';
    wait for t*2;

    clear <= '0';
    wait for t*4;

    -- s0 to s1	 
    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*2;

    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*4;

    -- s1 to s2
    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*2;

    disp <= '1';
    wait for t*2;

    disp <= '0';
    wait for t*4;

    -- s2 to s4
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

configuration calc_state_test of testbench_calc_state is
  for sim
  end for;
end calc_state_test;