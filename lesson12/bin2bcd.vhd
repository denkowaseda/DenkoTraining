library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.all;

entity bin2bcd is
port(
  ans : in std_logic_vector(7 downto 0);
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of bin2bcd is

signal b_in : integer range 0 to 255;
signal q1_out, q2_out, q3_out : integer range 0 to 15;
--signal q2_out : integer range 0 to 127;
--signal q3_out : integer range 0 to 1023;

begin
  b_in <= conv_integer(ans);
  q1_out <= b_in - (b_in / 10)*10;
  q2_out <= b_in/10 - ((b_in/10)/10)*10;
  q3_out <= b_in/100-((b_in/100)/10)*10;

  digit3 <= conv_std_logic_vector(q3_out, 4);
  digit2 <= conv_std_logic_vector(q2_out, 4);
  digit1 <= conv_std_logic_vector(q1_out, 4);

end rtl;