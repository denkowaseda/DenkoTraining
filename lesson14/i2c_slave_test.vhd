Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY testbench_i2c_slave IS
END testbench_i2c_slave;

ARCHITECTURE sim OF testbench_i2c_slave IS

COMPONENT i2c_slave
 port (
-- generic ports
 XRESET  : in  std_logic;                     -- System Reset
 sysclk	: in	std_logic;
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
END COMPONENT;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant i,j : integer := 0;

type BYTE_DATA is array(1 to 8) of std_logic;
constant slaveaddr_w : BYTE_DATA := ('1','0','1','0','0','1','0','0');
constant slaveaddr_r : BYTE_DATA := ('1','0','1','0','0','1','0','1');
constant i2cregaddr_00 : BYTE_DATA := ('0','0','0','0','0','0','0','0');
constant i2cregdata_55 : BYTE_DATA := ('0','1','0','1','0','1','0','1');
constant i2cregdata_AA : BYTE_DATA := ('1','0','1','0','1','0','1','0');

type REGARRAY is array(0 to 7,0 to 7) of std_logic;
constant data_patarn : REGARRAY := (('0','0','0','0','0','0','0','0'), -- 0 X"00"
                                    ('1','1','1','1','1','1','1','1'), -- 1 X"FF"
                                    ('0','1','0','1','0','1','0','1'), -- 2 X"55"
                                    ('1','0','1','0','1','0','1','0'), -- 3 X"AA"
                                    ('1','1','0','0','1','1','0','0'), -- 4 X"EE"
                                    ('0','0','1','1','0','0','1','1'), -- 5 X"33"
                                    ('1','1','1','1','0','0','0','0'), -- 6 X"F0"
                                    ('0','0','0','0','1','1','1','1')   --7 X"0F
                                   );

signal reset,clk,ready,scl_in,sda_in : std_logic;
signal start,stop,r_w,data_vld,scl_oe,sda_oe : std_logic;
signal data_in,data_out,send_data : std_logic_vector(7 downto 0);

  --=======================
  -- I2C Send Operation
  --=======================
  procedure i2c_send(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic;
--	 signal data : in std_logic_vector(7 downto 0);
    m : in integer;
    n : in integer
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
--    for i in 7 downto 0 loop		
--      wait for scl_period / 2;
--      sda_o <= data(i);
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
        sda_o <= data_patarn(j,i);
			
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
    end loop;
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
    signal sda_o : out std_logic;
    n : in integer
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
      sda_o <= '0';
		
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

	U2: i2c_slave port map (XRESET=>reset,sysclk=>clk,ready=>ready,start=>start,stop=>stop,data_in=>data_in,
									data_out=>data_out,r_w=>r_w,data_vld=>data_vld,scl_in=>scl_in,
									scl_oe=>scl_oe,sda_in=>sda_in,sda_oe=>sda_oe);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
		
	PROCESS BEGIN
		reset <= '1';
		scl_in <= '1';
		sda_in <= '1';
		ready <= '1';
		data_in <= "11001100";
		
		wait for cycle*100;
		reset <= '0';

    i2c_send(scl_o => scl_in, sda_o => sda_in, m => 5, n => 5);
    wait for 50 us;
    i2c_receive(scl_o => scl_in, sda_o => sda_in, n => 0);
    wait for 50 us;
    i2c_send(scl_o => scl_in, sda_o => sda_in, m => 2, n => 3);
    wait for 50 us;
    data_in <= "10101010";
    i2c_receive(scl_o => scl_in, sda_o => sda_in, n => 1);
    wait for 100 us;
--    i2c_write(scl_o => scl_in, sda_o => sda_in);
		
		wait;
	end PROCESS;
	
end sim;

CONFIGURATION i2c_slave_test of testbench_i2c_slave IS
	for sim
	end for;
end i2c_slave_test;