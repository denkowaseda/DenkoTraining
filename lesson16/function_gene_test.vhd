library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_function_gene is
end testbench_function_gene;

architecture sim of testbench_function_gene is

component function_gene
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
end component;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant i : integer := 0;
constant j : integer := 0;

type BYTE_DATA is array(1 to 8) of std_logic;
constant slaveaddr_w : BYTE_DATA := ('H','0','H','0','0','H','0','0');
constant slaveaddr_r : BYTE_DATA := ('H','0','H','0','0','H','0','H');
constant i2cregaddr_00 : BYTE_DATA := ('0','0','0','0','0','0','0','0');
constant i2cregdata_55 : BYTE_DATA := ('0','H','0','H','0','H','0','H');
constant i2cregdata_AA : BYTE_DATA := ('H','0','H','0','H','0','H','0');
constant i2cregdata_F0 : BYTE_DATA := ('H','H','H','H','0','0','0','0');

type REGARRAY is array(0 to 7,0 to 7) of std_logic;
constant data_patarn : REGARRAY := (('0','0','0','0','0','0','0','0'), -- 0 X"00"
                                    ('H','H','H','H','H','H','H','H'), -- 1 X"FF"
                                    ('0','H','0','H','0','H','0','H'), -- 2 X"55"
                                    ('H','0','H','0','H','0','H','0'), -- 3 X"AA"
                                    ('H','H','0','0','H','H','0','0'), -- 4 X"EE"
                                    ('0','0','H','H','0','0','H','H'), -- 5 X"33"
                                    ('H','H','H','H','0','0','0','0'), -- 6 X"F0"
                                    ('0','0','0','0','H','H','H','H')  -- 7 X"0F
                                   );

signal reset,clk,ready,scl_in,sda,sda_in : std_logic;
signal dipsw1,dipsw2,led,motor : std_logic_vector(7 downto 0);
signal send_data,reg_addr : std_logic_vector(7 downto 0);
signal daout : std_logic_vector(9 downto 0);
signal isda : std_logic;

  --=======================
  -- I2C Register Write
  --=======================
  procedure i2c_regWrite(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic;
    signal reg_addr : in std_logic_vector(7 downto 0);
	 signal data : in std_logic_vector(7 downto 0)
--    m : in integer;
--    n : in integer
  ) is
  constant scl_period : time := 2.5 us;
  begin
    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda_o <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start
    --********************
    -- Send slave address
    --********************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda_o <= slaveaddr_w(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H'; --'0'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --*********************
    -- Send register address
    --*********************
    for i in 7 downto 0 loop		
      wait for scl_period / 2;
      sda_o <= reg_addr(i);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
    
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H'; --'0'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --*********************
    -- Send data
    --*********************
    for i in 7 downto 0 loop		
      wait for scl_period / 2;
      sda_o <= data(i);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
    
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H'; --'0'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
    sda_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= 'H';
  end procedure;

  --=======================
  -- I2C Register Read 
  --=======================
  procedure i2c_regRead(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic;
    signal reg_addr : std_logic_vector(7 downto 0)
  ) is
  constant scl_period : time := 2.5 us;
  begin
    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda_o <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start

    --*************************
    -- Send slave address(write)
    --*************************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda_o <= slaveaddr_w(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --*********************
    -- Send register address
    --*********************
    for i in 7 downto 0 loop		
      wait for scl_period / 2;
      sda_o <= reg_addr(i);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;

    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
    sda_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= 'H'; --'1';

    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda_o <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start

    --*************************
    -- Send slave address(read)
    --*************************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda_o <= slaveaddr_r(i+1);

      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;

    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= 'H';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
--    sda_o <= 'H';
	 
	 --***************************
    --SCL for read data transfer
    --***************************
    for i in 0 to 7 loop
      wait for scl_period;
      scl_o <= '1';
      wait for scl_period;
      scl_o <= '0';
    end loop;
    sda_o <= 'H'; --'1';
	 
    --************************
    -- Not acknowledge from master
    --************************
    wait for scl_period / 2;
    sda_o <= 'H'; --'1';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    wait for scl_period / 2;
    sda_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period / 2;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= 'H'; --'1';

  end procedure;

begin
  u1: function_gene port map (reset => reset, clk40m => clk, dipsw1 => dipsw1, dipsw2 => dipsw2, daout => daout,
                               led => led, motor => motor, isda => isda, sda => sda, scl => scl_in);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;

  process begin	
    reset <= '0';
    scl_in <= '1';
    sda <= '1';
    ready <= '1';
    dipsw1 <= "00001111";
    dipsw2 <= "01110000";
		
    wait for cycle*100;
    reset <= '1';

    reg_addr <= "00000000";
	 i2c_regRead(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr);
	 wait for 100 us;
	 
    reg_addr <= "0000000H";
	 i2c_regRead(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr);
	 wait for 50 us;
	 
    --*******************
    -- Sine wave at 1kHz
    --*******************
    reg_addr <= "00000HHH"; -- Selmap Register
    send_data <= "00000000"; -- Rom addresses are 0 to 63
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "000000HH"; -- ACC Register1
    send_data <= "HH0HH0HH"; -- X"DB"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
 
    reg_addr <= "00000H00"; -- ACC Register2
    send_data <= "0HH0H000"; -- X"68"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "00000H0H"; -- ACC Register3
    send_data <= "00000000";-- X"00"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 5 ms;	

    -- Repeat same setting
    reg_addr <= "00000HHH"; -- Selmap Register
    send_data <= "00000000"; -- Rom addresses are 0 to 63
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "000000HH"; -- ACC Register1
    send_data <= "HH0HH0HH";
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
 
    reg_addr <= "00000H00"; -- ACC Register2
    send_data <= "0HH0H000";
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "00000H0H"; -- ACC Register3
    send_data <= "00000000";
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 5 ms;	

    --********************
    -- Square Wave at 1kHz
    --********************
    reg_addr <= "00000111"; -- Selmap Register
    send_data <= "00000001"; -- Rom addresses are 64 to 127
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 5 ms;
 
    --********************
    -- Sawteeth Wave at 1kHz
    --********************
    reg_addr <= "00000111"; -- Selmap Register
    send_data <= "00000010"; -- Rom addresses are 128 to 191
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 5 ms;
 
    --********************
    -- Triangle Wave at 1kHz
    --********************
    reg_addr <= "00000111"; -- Selmap Register
    send_data <= "00000011"; -- Rom addresses are 192 to 256
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 5 ms;

    -- Change freq. to 100Hz 
    reg_addr <= "00000011"; -- ACC Register1
    send_data <= "01111100"; -- X"7C"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "00000100"; -- ACC Register2
    send_data <= "00001010"; -- X"0A"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);
    wait for 50 us;

    reg_addr <= "00000101"; -- ACC Register3
    send_data <= "00000000"; -- X"00"
    i2c_regWrite(scl_o => scl_in, sda_o => sda, reg_addr => reg_addr, data => send_data);

    wait;
  end PROCESS;
	
end sim;

CONFIGURATION function_gene_test of testbench_function_gene IS
	for sim
	end for;
end function_gene_test;