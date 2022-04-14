library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity seven_seg is
port(
  din : in std_logic_vector( 3 downto 0);
  dout : out std_logic_vector( 7 downto 0)
);
end seven_seg;

architecture rtl of seven_seg is
begin
  process( din )
  begin
    case  din is	-- Low active 
      when "0000" => dout <= "00000011"; -- 0:abcdef-
      when "0001" => dout <= "10011111"; -- 1:-bc----
      when "0010" => dout <= "00100101"; -- 2:ab-de-g
      when "0011" => dout <= "00001101"; -- 3:abcd--g
      when "0100" => dout <= "10011001"; -- 4:-bc--fg
      when "0101" => dout <= "01001001"; -- 5:a-cd-fg
      when "0110" => dout <= "01000001"; -- 6:a-cdefg
      when "0111" => dout <= "00011111"; -- 7:abc----
      when "1000" => dout <= "00000001"; -- 8:abcdefg
      when "1001" => dout <= "00001001"; -- 9:abcd-fg
      when "1010" => dout <= "00000101"; -- a:abcde-g
      when "1011" => dout <= "11000001"; -- b:--cdefg
      when "1100" => dout <= "01100011"; -- C:a--def-
      when "1101" => dout <= "10000101"; -- d:-bcde-g
      when "1110" => dout <= "01100001"; -- E:-bc----
      when "1111" => dout <= "01110001"; -- F:a--defg
      when others => dout <= "11111111";
--                            abcdefg.
    end case;
  end process;
end rtl; 