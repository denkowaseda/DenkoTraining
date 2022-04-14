library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity chatter is
port(
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  sw : in std_logic_vector(3 downto 0);
  swo : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of chatter is

signal presentSwState, nextSwState : std_logic_vector(3 downto 0);
signal count : std_logic_vector(3 downto 0);

begin

process(reset, clock)
begin
  if(reset = '0') then
    count <= "0000";
  elsif(clock'event and clock='1') then
    if(en = '1') then
      count <= count + 1;
    else
      count <= count;
    end if;
  end if;
end process;

process(reset, clock)
begin
  if(reset = '0') then
    presentSwState <= "1111";
    nextSwState <= "1111";
  elsif(clock'event and clock='1') then
    if((en = '1') and (count = "0000")) then
      presentSwState <= sw;
	   nextSwState <= presentSwState;
    end if;
  end if;
	 end process;

swo <= nextSwState;
end rtl;