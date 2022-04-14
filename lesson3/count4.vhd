library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE WORK.ALL;

entity count4 is
  port (
    reset : in std_logic;
    clock : in std_logic;
    q : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of count4 is 

signal iq : std_logic_vector(3 downto 0);

begin
  process(reset, clock)
  begin
    if(reset = '0') then
      iq <= "0000";
    elsif(clock'event and clock = '1') then
      iq <= iq + 1;
    end if;
  end process;
  q <= iq;
end rtl;