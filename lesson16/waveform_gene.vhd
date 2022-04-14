library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity waveform_gene is 
port (
clock : in std_logic;
reset : in std_logic;
daout : out std_logic_vector(9 downto 0));
end waveform_gene;

architecture rtl of waveform_gene is

component waveforms
port (
clock : in std_logic;
reset : in std_logic;
en : in std_logic;
daout : out std_logic_vector(11 downto 0));
end component;

signal en : std_logic;
signal adr_cnt : std_logic_vector(9 downto 0);
signal dout : std_logic_vector(11 downto 0);

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

u1 : waveforms port map(clock => clock, reset => reset, en => en, daout => dout);

daout <= dout(9 downto 0);
--daout <= not dout(9) & dout(8 downto 0);
    
end rtl;