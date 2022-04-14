library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity selector4to1 is
  port (
    s1 : in std_logic;
    s2 : in std_logic;
    d : in std_logic_vector(3 downto 0);
    y : out std_logic
  );
end;

architecture rtl of selector4to1 is 
begin 
  y <= (not s1 and not s2 and d(0))
    or (s1 and not s2 and d(1)) 
    or (not s1 and s2 and d(2)) 
    or (s1 and s2 and d(3));
end rtl;