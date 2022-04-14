library ieee;
use ieee.std_logic_1164.all;
USE WORK.ALL;

entity led1 is
  port (
  clk40m : in std_logic;
  PB : in std_logic;
  LED : out std_logic;
  dummy : out std_logic
  );
end;

architecture rtl of led1 is 
begin 
  LED <= not PB;	
  dummy <= clk40m;
end rtl;