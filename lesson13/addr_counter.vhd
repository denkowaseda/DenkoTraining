library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity addr_counter is
port(
reset : in std_logic;
clock : in std_logic;
rom_addr : out std_logic_vector(5 downto 0)
);
end addr_counter;

architecture rtl of addr_counter IS
signal en : std_logic;
signal irom_addr : std_logic_vector(5 downto 0);
signal adr_cnt : std_logic_vector(9 downto 0);

begin

process(reset,clock) begin
  if(reset = '0') then
    adr_cnt <= "0000000000";
    en <= '0';
  elsif(clock'event and clock='1') then
    if (adr_cnt = "1001110000") then
      adr_cnt <= "0000000000";
      en <= '1';
    else
      adr_cnt <= adr_cnt + '1';
      en <= '0';
    end if;
  end if;
end process;

process(reset,clock) begin
  if(reset = '0') then
    irom_addr <= "000000";
  elsif(clock'event and clock='1') then
    if(en = '1') then
      irom_addr <= irom_addr + 1;
    else
      irom_addr <= irom_addr;
    end if;
  end if;
end process;

rom_addr <= irom_addr;

end RTL;