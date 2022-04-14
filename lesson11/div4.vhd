library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity div4 is
port (
  a : in std_logic_vector(3 downto 0);
  q : out std_logic_vector(3 downto 0);
  r : out std_logic_vector(3 downto 0)
);
end;

architecture rtl of div4 is 

signal a_in : integer range 0 to 15;
signal q_out, r_out : integer range 0 to 15;
 
begin 
  a_in <= conv_integer(a);
  q_out <= a_in/3;
  r_out <= a_in mod 3;
  q <= conv_std_logic_vector(q_out, 4);
  r <= conv_std_logic_vector(r_out, 4);
end rtl;