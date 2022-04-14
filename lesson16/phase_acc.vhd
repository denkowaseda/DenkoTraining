library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity phase_acc is
port(
  reset : in std_logic;
  clock : in std_logic;
  acc_reg1 : in std_logic_vector(7 downto 0);
  acc_reg2 : in std_logic_vector(7 downto 0);
  acc_reg3 : in std_logic_vector(7 downto 0);
  addr_cen : out std_logic -- Address count enable for waveform rom
);
end phase_acc;

architecture rtl of phase_acc is

signal dfout : std_logic;
signal phase_acc: std_logic_vector(23 downto 0);
signal acc_reg : std_logic_vector (21 downto 0);

begin
  acc_reg <= acc_reg3(5 downto 0) & acc_reg2 & acc_reg1;

  process(clock,reset) begin
    if(reset = '0') then
      phase_acc <= (others => '0');--"000000000000000000000000";
    elsif(clock'event and clock='1') then
        phase_acc <= phase_acc + acc_reg;
    end if;
  end process;
  
  process(clock,reset) begin
    if(reset = '0') then
      dfout <= '0';
    elsif(clock'event and clock='1') then
      dfout <= phase_acc(23);
    end if;
  end process;
  
  addr_cen <= not phase_acc(23) and dfout;

end rtl;