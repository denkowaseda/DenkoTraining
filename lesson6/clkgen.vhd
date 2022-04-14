library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity clkgen is
port(
reset : in std_logic;
clock : in std_logic;
clk_msec : in std_logic;
blink_on : out std_logic
);
end clkgen;

architecture rtl of clkgen IS

constant sim : integer := 1;
signal clk_sec, iblink_on : std_logic;
signal count : std_logic_vector(9 downto 0);

begin

COMPILE : if sim /= 1 generate
-- 1/1000
process(reset,clock) begin
  if(reset = '0') then
    count <= "0000000000";
    clk_sec <= '0';
  elsif(clock'event and clock='1') then
    if clk_msec = '1' then
      if count = "1111100111" then
        count <= "0000000000";
		  clk_sec <= '1';
      else
        count <= count + 1;
        clk_sec <= '0';
      end if;
    else
      count <= count;
      clk_sec <= '0';
    end if;
  end if;
end process;
end generate;

SIMULATION : if sim = 1 generate
-- 1/100 for simulation
process(reset,clock) begin
  if(reset = '0') then
    count <= "0000000000";
    clk_sec <= '0';
  elsif(clock'event and clock='1') then
    if clk_msec = '1' then
      if count = "0001100011" then
        count <= "0000000000";
		  clk_sec <= '1';
      else
        count <= count + 1;
        clk_sec <= '0';
      end if;
    else
      count <= count;
      clk_sec <= '0';
    end if;
  end if;
end process;
end generate;

process(reset,clock) begin
  if(reset = '0') then
    iblink_on <= '0';
  elsif(clock'event and clock='1') then
    if(clk_sec = '1') then
      iblink_on <= not iblink_on;
    end if;
  end if;	 
end process;
blink_on <= iblink_on;
end RTL;