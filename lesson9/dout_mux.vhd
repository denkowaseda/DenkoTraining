library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity dout_mux is
port(
  sel : in std_logic_vector(2 downto 0);
  din1, din2,din3 : in std_logic_vector(3 downto 0);
  dout : out std_logic_vector(7 downto 0)
);
end dout_mux;

architecture rtl of dout_mux is

component seven_seg
port(
  din : in std_logic_vector( 3 downto 0);
  dout : out std_logic_vector( 7 downto 0)
);
end component;

signal dout1, dout2, dout3 : std_logic_vector(7 downto 0);

begin
  u1 : seven_seg port map(din => din1, dout => dout1);
  u2 : seven_seg port map(din => din2, dout => dout2);
  u3 : seven_seg port map(din => din3, dout => dout3);

  process(sel, dout1, dout2, dout3)
  begin
    case sel is
      when "011" => dout <= dout3;
      when "101" => dout <= dout2;
      when "110" => dout <= dout1;
      when others => dout <= "11111111";
    end case;
  end process;
end rtl; 