library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity testbench_chatter is
end testbench_chatter;

architecture sim of testbench_chatter is 

constant t : time := 100 ns;

component chatter
port(
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  sw : in std_logic_vector(3 downto 0);
  swo : out std_logic_vector(3 downto 0)
  );
end component;

signal reset, clock, en : std_logic;
signal sw,swo : std_logic_vector(3 downto 0);

begin 
  u1 : chatter port map(
  reset => reset,
  clock => clock,
  en => en,
  sw => sw,
  swo => swo
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
    wait for 1 ns;
    en <= '1';
    wait for t;

    en <= '0';
    wait for t*6;
	 
    en <= '1';
    wait for t-1 ns;
  end process;
  
  process
  begin
    reset <= '0';
    sw <= "1111";
    wait for 25 ns;
	
    reset <= '1';
    wait for t*10;
	 
    sw <= "0000";
	 wait for t*10;
	 
	 sw <= "1111";
    wait for t*10;

    sw <= "0000";
    wait for t*10;
	 
    sw <= "1111";
    wait for t*10;
	 
    sw <= "0000";
	 wait for t*200;
	 
    sw <= "1111";

    wait;
  end process;
end sim;

configuration chatter_test of testbench_chatter is
  for sim
  end for;
end chatter_test;