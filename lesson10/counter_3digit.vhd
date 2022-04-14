library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity counter_3digit is
  port (
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  digit1 : out std_logic_vector(3 downto 0);
  digit2 : out std_logic_vector(3 downto 0);
  digit3 : out std_logic_vector(3 downto 0)
  );
end;

architecture rtl of counter_3digit is 

component count_enable
  port (
  reset : in std_logic;
  clock : in std_logic;
  en : in std_logic;
  q : out std_logic_vector(3 downto 0)
  );
end component;

signal en1,en2 : std_logic;
signal idigit1,idigit2,idigit3 : std_logic_vector(3 downto 0);

begin
  u1 : count_enable port map(reset => reset, clock => clock, en => en, q => idigit1);
  u2 : count_enable port map(reset => reset, clock => clock, en => en1, q => idigit2);
  u3 : count_enable port map(reset => reset, clock => clock, en => en2, q => idigit3);

  process(en, idigit1)
  begin
    if ((idigit1 = "1001") and (en ='1')) then
      en1 <= '1';
    else
     en1 <= '0';
    end if;
  end process;
  
  process(en1, idigit2)
  begin
    if ((idigit2 = "1001") and (en1 = '1')) then
      en2 <= '1';
    else
      en2 <= '0';
    end if;
  end process;
  
  digit1 <= idigit1;
  digit2 <= idigit2;
  digit3 <= idigit3;
  
end rtl;