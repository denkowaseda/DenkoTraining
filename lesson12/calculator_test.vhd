library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_calculator is
end testbench_calculator;

architecture sim of testbench_calculator is 

constant t : time := 12.5 ns;

component calculator
port (
  clk40m : in std_logic;
  reset : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  seg_a : out std_logic;
  seg_b : out std_logic;
  seg_c : out std_logic;
  seg_d : out std_logic;
  seg_e : out std_logic;
  seg_f : out std_logic;
  seg_g : out std_logic;
  seg_dot : out std_logic;
  sel0 : out std_logic;
  sel1 : out std_logic;
  sel2 : out std_logic;
  led : out std_logic
  );
end component;

signal reset, clk40m : std_logic;
signal seg_a, seg_b, seg_c, seg_d : std_logic;
signal seg_e, seg_f, seg_g, seg_dot : std_logic;
signal sel0, sel1, sel2, led : std_logic;
signal swIn : std_logic_vector(3 downto 0);
signal a, b : std_logic_vector(7 downto 0);

begin 
  u1 : calculator port map(
  clk40m => clk40m,
  reset => reset,
  swIn => swIn,
  a => a,
  b => b,
  seg_a => seg_a,
  seg_b => seg_b,
  seg_c => seg_c,
  seg_d => seg_d,
  seg_e => seg_e,
  seg_f => seg_f,
  seg_g => seg_g,
  seg_dot => seg_dot,
  sel0 => sel0,
  sel1 => sel1,
  sel2 => sel2,
  led => led
  );
  process
  begin
    clk40m <= '0';
    wait for t;
	
    clk40m <= '1';
    wait for t;
  end process;
  
  process
  begin
    reset <= '0';
    swIn <= "1111";
    a <= "00000000";
    b <= "00000000";
    wait for t*2;
	
    reset <= '1';
    wait for t*2;
	 
    a <= "00001010";
    b <= "00001111";
	 wait for t*2000;
	 
	 swIn <= "1110"; -- Display a(10D)
    wait for t*2000;

    swIn <= "1111";
    wait for t*2000;
	 
    swIn <= "1110"; -- Display b(15D)
    wait for t*2000;
	 
    swIn <= "1111";
	 wait for t*2000;
	 
    swIn <= "0111"; -- 10 + 15
    wait for t*2000;

    swIn <= "1111";
    wait for t*2000;

    swIn <= "1101"; -- clear
    wait for t*2000;

    swIn <= "1111";
    wait for t*2000;

    swIn <= "1110"; -- Display a(10D)
    wait for t*2000;

    swIn <= "1111";
    wait for t*2000;

    swIn <= "1110"; -- Display b(15D)
    wait for t*2000;

    swIn <= "1111";
    wait for t*2000;

    swIn <= "1011"; -- 10 x 15
    wait for t*2000;

    swIn <="1111";
    wait for t*2000;

    swIn <="1101"; -- clear
    wait for t*2000;

    swIn <="1111";
    wait for t*2000;

    wait;
  end process;
end sim;

configuration calculator_test of testbench_calculator is
  for sim
  end for;
end calculator_test;