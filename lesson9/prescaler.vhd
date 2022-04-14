library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity prescaler is
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : out std_logic
);
end;

architecture rtl of prescaler is

signal counter_msec : std_logic_vector(15 downto 0);
constant sim : integer := 0;

begin
--Generate 1msec timer
COMPILE : if sim /= 1 generate
-- 1/40000
process(reset,clock) begin
  if(reset = '0') then
    counter_msec <= "0000000000000000";
    clk_msec <= '0';
  elsif(clock'event and clock='1') then
    if counter_msec = "1001110000111111" then
      counter_msec <= "0000000000000000";
      clk_msec <= '1';
  else
    counter_msec <= counter_msec + '1';
    clk_msec <= '0';
  end if;
end if;
end process;
end generate;

SIMULATION : if sim = 1 generate
-- 1/40
process(reset,clock) begin
  if(reset = '0') then
    counter_msec <= "0000000000000000";
    clk_msec <= '0';
  elsif(clock'event and clock='1') then
    if counter_msec = "0000000000100111" then
      counter_msec <= "0000000000000000";
      clk_msec <= '1';
  else
    counter_msec <= counter_msec + '1';
    clk_msec <= '0';
  end if;
end if;
end process;
end generate;
end rtl;