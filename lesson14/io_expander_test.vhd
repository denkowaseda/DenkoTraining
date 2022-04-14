Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY testbench_io_expander IS
END testbench_io_expander;

ARCHITECTURE sim OF testbench_io_expander IS

COMPONENT io_expander
 PORT(
  clock : in std_logic;
  reset : in std_logic;
  scl : inout std_logic;
  sda : inout std_logic;
  sda_in : in std_logic;
  inport : in std_logic_vector(7 downto 0);
  outport : out std_logic_vector(7 downto 0)
);END COMPONENT;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant i : integer := 0;
constant j : integer := 0;

type BYTE_DATA is array(1 to 8) of std_logic;
constant slaveaddr_w : BYTE_DATA := ('1','0','1','0','0','1','0','0');
constant slaveaddr_r : BYTE_DATA := ('1','0','1','0','0','1','0','1');
constant i2cregaddr_00 : BYTE_DATA := ('0','0','0','0','0','0','0','0');
constant i2cregdata_55 : BYTE_DATA := ('0','1','0','1','0','1','0','1');
constant i2cregdata_AA : BYTE_DATA := ('1','0','1','0','1','0','1','0');
constant i2cregdata_F0 : BYTE_DATA := ('1','1','1','1','0','0','0','0');

type REGARRAY is array(0 to 3,0 to 7) of std_logic;
constant reg_map : REGARRAY := (('0','1','0','1','0','1','0','1'),
                                ('1','0','1','0','1','0','1','0'),
                                ('1','1','1','1','0','0','0','0'),
                                ('0','0','0','0','1','1','1','1'));

signal reset,clk,ready,scl_in,sda,sda_in : std_logic;
signal inport,outport,send_data : std_logic_vector(7 downto 0);

  --=======================
  -- I2C Send Operation
  --=======================
  procedure i2c_send(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic;
	 signal data : in std_logic_vector(7 downto 0)
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
    sda_o <= '0'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --*********************
    -- Send data
    --*********************
    for i in 7 downto 0 loop		
      wait for scl_period / 2;
      sda_o <= data(i);--i2cregdata_F0(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
	 
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= '0'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= '1';
  end procedure;

  --=======================
  -- I2C Receive Operation
  --=======================
  procedure i2c_receive(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic
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

--    --*************************
--    --repeated START condition
--    --*************************
--    wait for scl_period / 2;
--    sda_o <= '1';
--		
--    wait for scl_period / 2;
--    scl_o <= '1';
--		
--    wait for scl_period / 2;
--    sda_o <= '0';
--				
--    wait for scl_period / 2;
--    scl_o <= '0';

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
    sda_o <= '0';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --***************************
    --SCL for read data transfer
    --***************************
    for i in 0 to 7 loop
      wait for scl_period;
      scl_o <= '1';
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= '0';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= '1';
  end procedure;

  --===============================
  -- Random Address write operation
  --===============================
  procedure i2c_write(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic
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
    sda_o <= '0';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --*****************************
    -- Send register address(write)
    --*****************************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda_o <= i2cregaddr_00(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= '0';

    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --******************
    -- Send register data
    --*******************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda_o <= i2cregdata_55(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda_o <= '0';

    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= '1';
  end procedure;

BEGIN

	U2: io_expander port map (clock=>clk,reset=>reset,scl=>scl_in,
									sda=>sda, sda_in=>sda_in,inport=>inport,outport=>outport);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
		
	PROCESS BEGIN
		reset <= '0';
		scl_in <= '1';
		sda_in <= '1';
		ready <= '1';
--		data_in <= "10101010";
      inport <= "01010101";

		wait for cycle*100;
		reset <= '1';

--    i2c_receive(scl_o => scl_in, sda_o => sda_in);
--
--    wait for 50 us;
--
--    send_data <= "11001100";
--    i2c_send(scl_o => scl_in, sda_o => sda_in, data => send_data);
--
--    wait for 50 us;
--
--    send_data <= "00110011";
--    i2c_send(scl_o => scl_in, sda_o => sda_in, data => send_data);
--
--    inport <= "00001010";
--    i2c_receive(scl_o => scl_in, sda_o => sda_in);
--    wait for 50 us;
--    inport <= "11000101";
--    i2c_receive(scl_o => scl_in, sda_o => sda_in);

    send_data <= "00000011";
    i2c_send(scl_o => scl_in, sda_o => sda_in, data => send_data);
    i2c_receive(scl_o => scl_in, sda_o => sda_in);
--    i2c_write(scl_o => scl_in, sda_o => sda_in);
		
    wait;
  end PROCESS;
	
end sim;

CONFIGURATION io_expander_test of testbench_io_expander IS
	for sim
	end for;
end io_expander_test;