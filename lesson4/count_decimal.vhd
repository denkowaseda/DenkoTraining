library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity count_decimal is
  port (
  reset : in std_logic;
  clock : in std_logic;
  q : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of count_decimal is 

signal iq : std_logic_vector(3 downto 0);

begin
  process(reset, clock)
  begin
    if(reset = '0') then
      iq <= "0000";
    elsif(clock'event and clock = '1') then
      if(iq = "1001") then
        iq <= "0000";
      else
        iq <= iq + 1;
      end if;
    end if;
  end process;
  q <= iq;
end rtl;