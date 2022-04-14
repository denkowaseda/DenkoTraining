library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity io_expander is
PORT(
  clock : in std_logic;
  reset : in std_logic;
  scl : inout std_logic;
  isda : in std_logic; -- dummy port
  sda : inout std_logic;
  inport : in std_logic_vector(7 downto 0);
  outport : out std_logic_vector(7 downto 0)
);
end io_expander;

architecture rtl of io_expander is

component i2c_slave
 port (
-- generic ports
 XRESET  : in  std_logic;                     -- System Reset
 sysclk	: in 	std_logic;
 ready   : in  std_logic;                     -- back end system ready signal
 start   : out std_logic;                     -- start of the i2c cycle
 stop    : out std_logic;                     -- stop the i2c cycle
 data_in : in  std_logic_vector(7 DOWNTO 0);  -- parallel data in
 data_out: out std_logic_vector(7 DOWNTO 0);  -- parallel data out
 r_w     : out std_logic;                     -- read/write signal to the reg_map bloc
 data_vld: out std_logic;                     -- data valid from i2c
-- i2c ports
 scl_in  : in std_logic;                      -- SCL clock line
 scl_oe  : out std_logic;                     -- controls scl output enable
 sda_in  : in std_logic;                      -- i2c serial data line in
 sda_oe  : out std_logic                      -- controls sda output enable
 );
end component;

signal ready,start,stop,r_w,data_vld,xreset : std_logic;
signal sda_oe,sda_in,scl_in,scl_oe : std_logic;
signal data_in,data_out : std_logic_vector(7 downto 0);
signal in_reg,out_reg : std_logic_vector(7 downto 0);

begin
u1 : i2c_slave port map(XRESET => xreset, sysclk => clock, ready => ready, start => start,
     stop => stop, data_in => data_in, data_out => data_out, r_w => r_w, data_vld => data_vld,
     scl_in => scl, scl_oe => scl_oe, sda_in => sda_in, sda_oe => sda_oe);

--  process(clock,reset)
--  begin
--    if(reset = '0') then
--      in_reg <= "00000000";
--		out_reg <= "00000000";
--    elsif(clock'event and clock='1') then
--      if((r_w = '0') and (sda_oe = '1')) then
--        out_reg <= data_out;
--      elsif(r_w = '1') then
--        in_reg <= inport;
--      end if;
--    end if;
--  end process;

outport <= data_out;
data_in <= inport;
xreset <= not reset;

sda <= '0' when sda_oe = '1' else 'Z';
sda_in <= to_X01(sda) ;

scl <= '0' when scl_oe = '1' else 'Z';
scl_in <= scl;

ready <= '1';

end rtl;