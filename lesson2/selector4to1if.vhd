library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity selector4to1if is
  port (
    s1 : in std_logic;
    s2 : in std_logic;
    d : in std_logic_vector(3 downto 0);
    y : out std_logic
  );
end;

architecture rtl of selector4to1if is 
begin
  process(s1, s2, d)
  begin
    if(s1 = '0' and s2 = '0') then
      y <= d(0);
    elsif(s1 = '1' and s2 = '0') then
      y <= d(1);
    elsif(s1 = '0' and s2 =  '1') then
      y <= d(2);
    else
      y <= d(3);
    end if;
  end process;
end rtl;