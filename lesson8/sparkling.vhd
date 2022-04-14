library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity sparkling is
port(
reset : in std_logic;
clock : in std_logic;
clk_sec : in std_logic;
led : out std_logic_vector(7 downto 0)
);
end;

architecture rtl of sparkling is

signal count : std_logic_vector(3 downto 0);

begin

process(reset,clock) begin
  if(reset = '0') then
    count <= "0000";
  elsif(clock'event and clock='1') then
    if(clk_sec = '1') then
      count <= count + 1;
    else
      count <= count;
    end if;
    case count is
      when "0000" => led <= "00000000";
      when "0001" => led <= "10000001";
      when "0010" => led <= "01000010";
      when "0011" => led <= "00100100";
      when "0100" => led <= "00011000";
      when "0101" => led <= "00100100";
      when "0110" => led <= "01000010";
      when "0111" => led <= "10000001";
      when "1000" => led <= "11000000";
      when "1001" => led <= "01100000";
      when "1010" => led <= "00110000";
      when "1011" => led <= "00011000";
      when "1100" => led <= "00001100";
      when "1101" => led <= "00000110";
      when "1110" => led <= "00000011";
      when "1111" => led <= "11111111";
	   when others => led <= "XXXXXXXX";
    end case; 
  end if;
end process;
end rtl;