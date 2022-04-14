library ieee;
use ieee.std_logic_1164.all;
use work.all;

entity selector4to1case is
  port (
    s1 : in std_logic;
    s2 : in std_logic;
    d : in std_logic_vector(3 downto 0);
    y : out std_logic
  );
end;

architecture rtl of selector4to1case is 

signal sel : std_logic_vector(1 downto 0);

begin
  sel <= s2 & s1;
  process(sel, d)
  begin
    case (sel) is
      when "00" => y <= d(0);
      when "01" => y <= d(1);
      when "10" => y <= d(2);
      when "11" => y <= d(3);
      when others => y <= 'X';
    end case;
  end process;
end rtl;