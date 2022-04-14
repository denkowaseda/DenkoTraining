library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity function_gene is
port(
  reset : in std_logic;
  clk40m : in std_logic;
  dipsw1 : in std_logic_vector(7 downto 0);
  dipsw2 : in std_logic_vector(7 downto 0);
  daout : out std_logic_vector(9 downto 0);
  led : out std_logic_vector(7 downto 0);
  motor : out std_logic_vector(7 downto 0);
  isda : in std_logic;
  sda : inout std_logic;
  scl : inout std_logic
);
end function_gene;

architecture rtl of function_gene is

component i2c_slave
 PORT (
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

component reg_ctrl
port(
  reset : in std_logic;
  clock : in std_logic;
  start : in std_logic;
  stop : in std_logic;
  r_w : in std_logic;
  sda_oe : in std_logic;
  data_vld : in std_logic;
  data_i : in  std_logic_vector(7 DOWNTO 0);
  ready : out  std_logic;
  data_o : out std_logic_vector(7 DOWNTO 0); 
  dipsw1 : in std_logic_vector(7 downto 0);
  dipsw2 : in std_logic_vector(7 downto 0);
  led : out std_logic_vector(7 downto 0);
  acc_reg1 : out std_logic_vector(7 downto 0);
  acc_reg2 : out std_logic_vector(7 downto 0);
  acc_reg3 : out std_logic_vector(7 downto 0);
  motor : out std_logic_vector(7 downto 0);
  selmap : out std_logic_vector(7 downto 0)
);
end component;

component phase_acc
port(
  reset : in std_logic;
  clock : in std_logic;
  acc_reg1 : in std_logic_vector(7 downto 0);
  acc_reg2 : in std_logic_vector(7 downto 0);
  acc_reg3 : in std_logic_vector(7 downto 0);
  addr_cen : out std_logic -- Address count enable for waveform rom
);
end component;

component waveforms
port (
  clock : in std_logic;
  reset : in std_logic;
  en : in std_logic;
  selmap : in std_logic_vector(7 downto 0);
  daout : out std_logic_vector(9 downto 0));
end component;

signal xreset,ready,start,stop,r_w,data_vld : std_logic;
signal scl_in,scl_oe,sda_in,sda_oe : std_logic;
signal data_in,data_out : std_logic_vector(7 downto 0);
signal acc_reg1,acc_reg2,acc_reg3 : std_logic_vector(7 downto 0);
signal selmap : std_logic_vector(7 downto 0);
signal addr_cen : std_logic;

begin

  u1 : i2c_slave port map(XRESET => xreset, sysclk => clk40m, ready => ready, start => start, stop => stop,
                          data_in => data_in, data_out => data_out, r_w => r_w, data_vld => data_vld,
                          scl_in => scl_in, scl_oe => scl_oe, sda_in => sda_in, sda_oe => sda_oe);

  u2 : reg_ctrl port map(reset => reset, clock => clk40m, start => start, stop => stop, r_w => r_w, 
                         sda_oe => sda_oe, data_vld => data_vld, data_i => data_out, ready => ready,
                         data_o => data_in, dipsw1 => dipsw1, dipsw2 => dipsw2, led => led,acc_reg1 => acc_reg1,
                         acc_reg2 => acc_reg2, acc_reg3 => acc_reg3, motor => motor, selmap => selmap);

  u3 : phase_acc port map(reset => reset, clock => clk40m, acc_reg1 => acc_reg1, acc_reg2 => acc_reg2,
                          acc_reg3 => acc_reg3, addr_cen => addr_cen);

  u4 : waveforms port map(reset => reset, clock => clk40m, en => addr_cen, selmap => selmap, daout => daout);

  xreset <= not reset;

  sda <= '0' when sda_oe = '1' else 'Z';
  sda_in <= to_X01(sda) ;

  scl <= '0' when scl_oe = '1' else 'Z';
  scl_in <= scl;


end rtl;