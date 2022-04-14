library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity circular is
port(
reset : in std_logic;
clock : in std_logic;
en : in std_logic;
sel : out std_logic_vector(2 downto 0)
);
end;

architecture rtl of circular is

signal shift_reg : std_logic_vector(2 downto 0);

begin
  process(reset, clock)
  begin
    if (reset = '0') then
      shift_reg <= "110";
    elsif(clock'event and clock='1') then
	   if (en = '1') then
        shift_reg(0) <= shift_reg(2); 
        shift_reg(1) <= shift_reg(0);
        shift_reg(2) <= shift_reg(1);
      else
        shift_reg <= shift_reg;
      end if;
    end if;
  end process;
  sel <= shift_reg;

end rtl;