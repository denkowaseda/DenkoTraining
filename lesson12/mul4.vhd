library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity mul4 is
port (
  a : in std_logic_vector(3 downto 0);
  b : in std_logic_vector(3 downto 0);
  res : out std_logic_vector(7 downto 0)
  );
end;

architecture rtl of mul4 is 

begin 
--  res <= signed(a)*signed(b);
  res <= a*b;
end rtl;