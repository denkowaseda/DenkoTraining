library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_phase_acc is
end testbench_phase_acc;

architecture sim of testbench_phase_acc is

component phase_acc
port(
  reset : in std_logic;
  clock : in std_logic;
  acc_reg1 : in std_logic_vector(7 downto 0);
  acc_reg2 : in std_logic_vector(7 downto 0);
  acc_reg3 : in std_logic_vector(7 downto 0);
  addr_cen : out std_logic
);
end component;
	
constant t : time	:= 12.5 ns;

signal reset,clock,addr_cen : std_logic;
signal acc_reg1,acc_reg2,acc_reg3 : std_logic_vector(7 downto 0);

begin
  U1: phase_acc port map (reset=>reset,clock=>clock,acc_reg1=>acc_reg1,acc_reg2=>acc_reg2,acc_reg3=>acc_reg3,addr_cen=>addr_cen);
	 
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
    acc_reg1 <= "00000000"; acc_reg2 <= "00000000"; acc_reg3 <= "00000000";
    wait for t*100;

    reset <= '1';
    acc_reg1 <= "00000000"; acc_reg2 <= "00000000"; acc_reg3 <= "00010000";

    wait for t*100;
    acc_reg1 <= "00000000"; acc_reg2 <= "00000000"; acc_reg3 <= "00001000";

    wait for t*200;
    acc_reg1 <= "00000000"; acc_reg2 <= "00000000"; acc_reg3 <= "00000100";
    wait;
  end process;
end sim;

configuration phase_acc_test of testbench_phase_acc is
	for sim
	end for;
end phase_acc_test;