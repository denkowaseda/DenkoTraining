library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity waveforms is 
port (
clock : in std_logic;
reset : in std_logic;
en : in std_logic;
selmap : in std_logic_vector(7 downto 0);
daout : out std_logic_vector(9 downto 0));
end waveforms;

architecture rtl of waveforms is

signal romaddr : std_logic_vector(5 downto 0);
signal romdata : std_logic_vector(11 downto 0);
signal waveaddr : std_logic_vector(7 downto 0);

subtype wave is std_logic_vector(11 downto 0);
type rom is array(0 to 255) of wave;
  constant func : rom :=(
  -- Sine WAve
  X"1FF", X"221", X"243", X"264", X"284", X"2A3", X"2C1", X"2DD",
  X"2F6", X"30D", X"322", X"333", X"342", X"34D", X"356", X"35B",
  X"35D", X"35B", X"356", X"34D", X"342", X"333", X"322", X"30D",
  X"2F6", X"2DD", X"2C1", X"2A3", X"284", X"264", X"243", X"221",
  X"1FF", X"1DC", X"1BA", X"199", X"179", X"15A", X"13C", X"120",
  X"107", X"0F0", X"0DB", X"0CA", X"0BB", X"0B0", X"0A7", X"0A2",
  X"0A1", X"0A2", X"0A7", X"0B0", X"0BB", X"0CA", X"0DB", X"0F0",
  X"107", X"120", X"13C", X"15A", X"179", X"199", X"1BA", X"1DC",
  -- Square wave
  X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E",
  X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E",
  X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E",
  X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E", X"35E",
  X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1",
  X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1",
  X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1",
  X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1", X"0A1",
  -- Sawtooth Wave
  X"0A1", X"0AC", X"0B7", X"0C2", X"0CD", X"0D8", X"0E3", X"0EE",
  X"0F9", X"105", X"110", X"11B", X"126", X"131", X"13C", X"147",
  X"152", X"15D", X"169", X"174", X"17F", X"18A", X"195", X"1A0",
  X"1AB", X"1B6", X"1C1", X"1CD", X"1D8", X"1E3", X"1EE", X"1F9",
  X"204", X"20F", X"21A", X"225", X"231", X"23C", X"247", X"252",
  X"25D", X"268", X"273", X"27E", X"289", X"295", X"2A0", X"2AB",
  X"2B6", X"2C1", X"2CC", X"2D7", X"2E2", X"2ED", X"2F9", X"304",
  X"30F", X"31A", X"325", X"330", X"33B", X"346", X"351", X"35D",
  -- Triangle wave
  X"1FF", X"214", X"22A", X"240", X"256", X"26C", X"282", X"298",
  X"2AE", X"2C3", X"2D9", X"2EF", X"305", X"31B", X"331", X"347",
  X"35D", X"347", X"331", X"31B", X"305", X"2EF", X"2D9", X"2C3",
  X"2AE", X"298", X"282", X"26C", X"256", X"240", X"22A", X"214",
  X"1FF", X"1E9", X"1D3", X"1BD", X"1A7", X"191", X"17B", X"165",
  X"150", X"13A", X"124", X"10E", X"0F8", X"0E2", X"0CC", X"0B6",
  X"0A1", X"0B6", X"0CC", X"0E2", X"0F8", X"10E", X"124", X"13A",
  X"150", X"165", X"17B", X"191", X"1A7", X"1BD", X"1D3", X"1E9"
  );

begin
  waveaddr <= selmap(1) & selmap(0) & romaddr;

  process(clock,reset) begin
    if (reset = '0') then
      romaddr <= "000000";
    elsif clock'event and clock='1' then
      if (en = '1') then
        romaddr <= romaddr + 1;
      else
        romaddr <= romaddr;
      end if;
    end if;
  end process;

  process(clock,romdata) begin
    if clock'event and clock='1' then
      romdata <= func(conv_integer(waveaddr));
    end if;
      daout <= romdata(9 downto 0);
  end process;
	
end rtl;