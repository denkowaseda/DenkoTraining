library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity adder8 is
port (
  a : in std_logic_vector(7 downto 0);
  b : in std_logic_vector(7 downto 0);
  s : out std_logic_vector(7 downto 0);
  co : out std_logic
  );
end;

architecture rtl of adder8 is 

signal si : std_logic_vector(8 downto 0);

begin 
  si <= ('0' & a) + ('0' & b);
  co <= '1' when ('0' & si) >= "100000000" else '0';
  s <= si(7 downto 0);
end rtl;