library ieee;
use ieee.std_logic_1164.all;
USE WORK.ALL;

entity testbenchcase is
end testbenchcase;

architecture sim of testbenchcase is 

constant	t : time	:= 100 ns;

signal s1,s2 : std_logic;
signal y : std_logic;
signal d : std_logic_vector(3 downto 0);

component selector4to1case
port (
	s1	: in  std_logic;
	s2	: in std_logic;
	d : in std_logic_vector(3 downto 0);
	y : out std_logic
	  );
end component;

begin 
	u1 : selector4to1case port map(
		s1	=> s1,
		s2	=> s2,
		d => d,
		y => y
	     );
process begin
		d <= "0001";
		s2 <= '0'; s1 <= '0';
		wait for t *1;
		s2 <= '0'; s1 <= '1';
		wait for t*1;
		s2 <= '1'; s1 <= '0';
		wait for t*1;
		s2 <= '1'; s1 <= '1';
		wait for t*1;
		
		d <= "0010";
		s2 <= '0'; s1 <= '0';
		wait for t *1;
		s2 <= '0'; s1 <= '1';
		wait for t*1;
		s2 <= '1'; s1 <= '0';
		wait for t*1;
		s2 <= '1'; s1 <= '1';
		wait for t*1;
		
		d <= "0100";
		s2 <= '0'; s1 <= '0';
		wait for t *1;
		s2 <= '0'; s1 <= '1';
		wait for t*1;
		s2 <= '1'; s1 <= '0';
		wait for t*1;
		s2 <= '1'; s1 <= '1';
		wait for t*1;
		
		d <= "1000";
		s2 <= '0'; s1 <= '0';
		wait for t *1;
		s2 <= '0'; s1 <= '1';
		wait for t*1;
		s2 <= '1'; s1 <= '0';
		wait for t*1;
		s2 <= '1'; s1 <= '1';
		wait for t*1;
	end process;
		
end sim;

CONFIGURATION selector4to1case_test of testbenchcase IS
	for sim
	end for;
end selector4to1case_test;