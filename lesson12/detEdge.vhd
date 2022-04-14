library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity detEdge is
port(
  reset : in std_logic;
  clock : in std_logic;
  swIn : in std_logic_vector(3 downto 0);
  detOut : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of detEdge is

signal dff_qaud : std_logic_vector(3 downto 0);
signal idetOut : std_logic_vector(3 downto 0);

begin

process(reset, clock)
begin
  if(reset = '0') then
    dff_qaud <= "1111";
  elsif(clock'event and clock='1') then
	 dff_qaud <= swIn;
  end if;
end process;

idetOut <= swIn and not dff_qaud;
detOut <= idetOut;
end rtl;