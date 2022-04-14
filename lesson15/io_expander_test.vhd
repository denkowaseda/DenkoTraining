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
  isda : in std_logic; -- dummy port
  sda : inout std_logic;
  inport : in std_logic_vector(7 downto 0);
  outport : out std_logic_vector(7 downto 0)
);END COMPONENT;
	
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
                                    ('0','0','0','0','H','H','H','H')   --7 X"0F
                                   );

signal reset,clk,ready,scl_in,sda,isda : std_logic;
signal inport,outport,send_data : std_logic_vector(7 downto 0);

  --=======================
  -- I2C Send Operation
  --=======================
  procedure i2c_send(
    signal scl_o : out std_logic;
    signal sda : inout std_logic;
    m : in integer;
    n : in integer
  ) is
  constant scl_period : time := 2.5 us;
  begin
    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start
    --********************
    -- Send slave address
    --********************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda <= slaveaddr_w(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda <= 'H'; -- ACK
		
    wait for scl_period / 2;
    scl_o <= '1';
	 sda <= '0';
		
    wait for scl_period;
    scl_o <= '0';

    --*********************
    -- Send data
    --*********************
--    for i in 7 downto 0 loop		
--      wait for scl_period / 2;
--      sda <= data(i);
--			
--      wait for scl_period / 2;
--      scl_o <= '1';
--			
--      wait for scl_period;
--      scl_o <= '0';
--    end loop;
    for j in m to n loop
      for i in 0 to 7 loop		
        wait for scl_period / 2;
        sda <= data_patarn(j,i);
			
        wait for scl_period / 2;
        scl_o <= '1';
			
        wait for scl_period;
        scl_o <= '0';
      end loop;	 
    
    --****************
    -- Acknowledge
    --****************
      wait for scl_period / 2;
      sda <= 'H';
      wait for scl_period / 2;
      scl_o <= '1';
		sda <= '0';
		
      wait for scl_period;
      scl_o <= '0';
    end loop;
    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda <= '1';
  end procedure;

  --=======================
  -- I2C Receive Operation
  --=======================
  procedure i2c_receive(
    signal scl_o : out std_logic;
    signal sda : inout std_logic;
    n : in integer
  ) is
  constant scl_period : time := 2.5 us;
  begin
    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start

--    --*************************
--    --repeated START condition
--    --*************************
--    wait for scl_period / 2;
--    sda <= '1';
--		
--    wait for scl_period / 2;
--    scl_o <= '1';
--		
--    wait for scl_period / 2;
--    sda <= '0';
--				
--    wait for scl_period / 2;
--    scl_o <= '0';

    --*************************
    -- Send slave address(read)
    --*************************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda <= slaveaddr_r(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda <= 'H';
		
    wait for scl_period / 2;
    scl_o <= '1';
--	 sda <= '0';
		
    wait for scl_period;
    scl_o <= '0';
		
    --***************************
    --SCL for read data transfer
    --***************************
    for j in 0 to n loop
      for i in 0 to 7 loop
        wait for scl_period;
        scl_o <= '1';
        wait for scl_period;
        scl_o <= '0';
      end loop;
		
    --************************
    -- Acknowledge from master
    --************************
      wait for scl_period / 2;
      sda <= '0';
		
      wait for scl_period / 2;
      scl_o <= '1';
		
      wait for scl_period;
      scl_o <= '0';
    end loop;
    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda <= '1';
  end procedure;

  --===============================
  -- Random Address write operation
  --===============================
  procedure i2c_write(
    signal scl_o : out std_logic;
    signal sda : out std_logic
  ) is
  constant scl_period : time := 2.5 us;
  begin

    --*****************
    -- START condition
    --*****************
    wait for scl_period;
    sda <= '0';
		
    wait for scl_period / 2;	
    scl_o <= '0';		-- start
		
    --********************
    -- Send slave address
    --********************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda <= slaveaddr_w(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda <= '0';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --*****************************
    -- Send register address(write)
    --*****************************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda <= i2cregaddr_00(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda <= '0';

    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';
		
    --******************
    -- Send register data
    --*******************
    for i in 0 to 7 loop		
      wait for scl_period / 2;
      sda <= i2cregdata_55(i+1);
			
      wait for scl_period / 2;
      scl_o <= '1';
			
      wait for scl_period;
      scl_o <= '0';
    end loop;
		
    --****************
    -- Acknowledge
    --****************
    wait for scl_period / 2;
    sda <= '0';

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
	 sda <= '1';
  end procedure;

BEGIN

	U2: io_expander port map (clock=>clk,reset=>reset,scl=>scl_in, isda=>isda, sda=>sda, inport=>inport,outport=>outport);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
		
	PROCESS BEGIN
		reset <= '0';
		scl_in <= '1';
		sda <= 'H';
		ready <= '1';
      inport <= "10101010";

		wait for cycle*100;
		reset <= '1';

    i2c_send(scl_o => scl_in, sda => sda, m => 2, n => 2);
    wait for 50 us;
    i2c_receive(scl_o => scl_in, sda => sda, n => 0);
		
    wait;
  end PROCESS;
	
end sim;

CONFIGURATION io_expander_test of testbench_io_expander IS
	for sim
	end for;
end io_expander_test;