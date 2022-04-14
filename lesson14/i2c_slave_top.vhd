Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY i2c_slave_top IS
PORT(
  clock : in std_logic;
  reset : in std_logic;
  scl : inout std_logic;
  sda : inout std_logic
);
END i2c_slave_top;

ARCHITECTURE RTL OF i2c_slave_top IS

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

signal ready,start,stop,r_w,data_vld : std_logic;
signal sda_oe,scl_oe,sda_in,scl_in : std_logic;
signal data_in,data_out : std_logic_vector(7 downto 0);

 begin

u1 : i2c_slave port map(XRESET => reset, sysclk => clock, ready => ready, start => start,
     stop => stop, data_in => data_in, data_out => data_out, r_w => r_w, data_vld => data_vld,
     scl_in => scl, scl_oe => scl_oe, sda_in => sda_in, sda_oe => sda_oe);

sda <= '0' when sda_oe = '1' else 'Z';
sda_in <= sda ;

scl <= '0' when scl_oe = '1' else 'Z';
scl_in <= scl;

end RTL;