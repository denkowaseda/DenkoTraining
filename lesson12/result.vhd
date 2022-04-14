library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity result is
port(
  reset : in std_logic;
  clock : in std_logic;
  add : in std_logic;
  multi : in std_logic;
  clear : in std_logic;
  s : in std_logic_vector(7 downto 0);
  m : in std_logic_vector(7 downto 0);
  res : out std_logic_vector( 7 downto 0)
  );
end;

architecture rtl of result is

constant s0 : std_logic_vector(1 downto 0) := "00";
constant s1 : std_logic_vector(1 downto 0) := "01";
constant s2 : std_logic_vector(1 downto 0) := "11";

signal present_state : std_logic_vector(1 downto 0);
signal next_state : std_logic_vector(1 downto 0);

--type states is (s0, s1, s2);
--signal present_state : states;
--signal next_state : states;

begin
  process(clock, reset)
  begin
    if (reset = '0') then
      present_state <= s0;
    elsif (clock'event and clock='1') then
      present_state <= next_state;
    end if;
  end process;

  process(present_state, s, m, clear, add, multi)
  begin
    case present_state is
      when s0 =>     
        if ( add = '1') then
          next_state <= s1;
        elsif ( multi = '1' ) then
          next_state <= s2;
        else
          next_state <= s0;
        end if;
      when s1 =>
        if (multi = '1') then
          next_state <= s2;
        elsif (clear = '1') then
          next_state <= s0;
        else
          next_state <= s1;
        end if;
      when s2 =>
        if (add = '1') then
          next_state <= s1;
        elsif (clear = '1') then
          next_state <= s0;
        else
          next_state <= s2;
        end if;
      when others =>
        next_state <= s0;
	  end case;
  end process;

  process(clock, reset)
  begin
    if (reset = '0') then
      res <= "00000000";
    elsif(clock'event and clock='1') then
      if(present_state = s0) then
        res <= "00000000";
      elsif(present_state = s1) then
        res <= s;
      elsif(present_state = s2) then
        res <= m;
      end if;
    end if;
  end process;
end rtl;