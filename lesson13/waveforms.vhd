library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity waveforms is 
port (
clock : in std_logic;
reset : in std_logic;
en : in std_logic;
daout : out std_logic_vector(11 downto 0));
end waveforms;

architecture rtl of waveforms is

signal romaddr : std_logic_vector(5 downto 0) ;
signal romdata : std_logic_vector(11 downto 0);

subtype wave is std_logic_vector(11 downto 0);
type rom is array(0 to 63) of wave;
  constant func : rom :=(
  X"1FF", X"221", X"243", X"264", X"284", X"2A3", X"2C1", X"2DD",
  X"2F6", X"30D", X"322", X"333", X"342", X"34D", X"356", X"35B",
  X"35D", X"35B", X"356", X"34D", X"342", X"333", X"322", X"30D",
  X"2F6", X"2DD", X"2C1", X"2A3", X"284", X"264", X"243", X"221",
  X"1FF", X"1DC", X"1BA", X"199", X"179", X"15A", X"13C", X"120",
  X"107", X"0F0", X"0DB", X"0CA", X"0BB", X"0B0", X"0A7", X"0A2",
  X"0A1", X"0A2", X"0A7", X"0B0", X"0BB", X"0CA", X"0DB", X"0F0",
  X"107", X"120", X"13C", X"15A", X"179", X"199", X"1BA", X"1DC" 
  );

begin

  process(clock,reset) begin
    if (reset = '0') then
      romaddr <= "000000";
    elsif clock'event and clock='1' then
      if (en = '1') then
        romaddr <= romaddr + 1;
      end if;
    end if;
  end process;

  process(clock,romdata) begin
    if clock'event and clock='1' then
      romdata <= func(conv_integer(romaddr));
    end if;
      daout <= romdata;
  end process;
	
end rtl;