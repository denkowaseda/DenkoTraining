Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY testbench_i2c_slave_top IS
END testbench_i2c_slave_top;

ARCHITECTURE sim of testbench_i2c_slave_top IS

COMPONENT i2c_slave_top
PORT(
  clock : in std_logic;
  reset : in std_logic;
  scl : in std_logic;
  sda : inout std_logic
);
END COMPONENT;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant i : integer := 0;

type BYTE_DATA is array(1 to 8) of std_logic;
constant slaveaddr_w : BYTE_DATA := ('1','0','1','0','0','1','0','0');
constant slaveaddr_r : BYTE_DATA := ('1','0','1','0','0','1','0','1');
constant i2cregaddr_00 : BYTE_DATA := ('0','0','0','0','0','0','0','0');
constant i2cregdata_55 : BYTE_DATA := ('0','1','0','1','0','1','0','1');
constant i2cregdata_AA : BYTE_DATA := ('1','0','1','0','1','0','1','0');

type REGARRAY is array(0 to 3,0 to 7) of std_logic;
constant reg_map : REGARRAY := (('0','1','0','1','0','1','0','1'),
											('1','0','1','0','1','0','1','0'),
											('1','1','1','1','0','0','0','0'),
											('0','0','0','0','1','1','1','1'));

signal reset,clk,scl,sda : std_logic;
signal sda_in : std_logic;

BEGIN

	U2: i2c_slave_top port map (clock => clk, reset => reset,scl => scl, sda => sda);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
		
	PROCESS BEGIN
		reset <= '1';
		scl <= '1';
		sda_in <= '1';
--		ready <= '1';
--		data_in <= "10101010";
		
		wait for cycle*100;
		reset <= '0';
	
--	--========================
--	-- Single write operation
--	--========================
--		--*****************
--		-- START condition
--		--*****************
--		wait for cycle*10;
--		sda_in <= '0';
--		
--		wait for cycle*5;	
--		scl <= '0';		-- start
--		
--		--********************
--		-- Send slave address
--		--********************
--		for i in 0 to 7 loop		
--		wait for cycle*5;
--			sda_in <= slaveaddr_w(i+1);
--			
--			wait for cycle*5;
--			scl <= '1';
--			
--			wait for cycle*10;
--			scl <= '0';
--		end loop;
--		
--		wait for cycle*5;
--		sda_in <= '0';
--		
--		wait for cycle*5;
--		scl <= '1';
--		
--		wait for cycle*10;
--		scl <= '0';
--		
--		--*****************************
--		-- Send register address(write)
--		--*****************************
--		for i in 0 to 7 loop		
--		wait for cycle*5;
--			sda_in <= i2cregaddr_00(i+1);
--			
--			wait for cycle*5;
--			scl <= '1';
--			
--			wait for cycle*10;
--			scl <= '0';
--		end loop;
--		
--		wait for cycle*5;
--		sda_in <= '0';
--		
--		wait for cycle*5;
--		scl <= '1';
--				
--		wait for cycle*10;
--		scl <= '0';
--		
--		--******************
--		-- Send register data
--		--*******************
--		for i in 0 to 7 loop		
--		wait for cycle*5;
--			sda_in <= i2cregdata_55(i+1);
--			
--			wait for cycle*5;
--			scl <= '1';
--			
--			wait for cycle*10;
--			scl <= '0';
--		end loop;
--		
--		wait for cycle*5;
--		sda_in <= '0';
--		
--		wait for cycle*5;
--		scl <= '1';
--		
--		wait for cycle*10;
--		scl <= '0';
--		
--		--****************
--		-- STOP confition
--		--****************
--		wait for cycle*10;
--		scl <= '1';
--		
--		wait for cycle*5;
--		sda_in <= '1';
--		
--		wait for cycle*10;
--		scl <= '1';
		
	--=======================
	-- Single read operation
	--=======================
		--*****************
		-- START condition
		--*****************
		wait for cycle*10;
		sda_in <= '0';
		
		wait for cycle*5;	
		scl <= '0';		-- start
		
		--********************
		-- Send slave address
		--********************
		for i in 0 to 7 loop		
		wait for cycle*5;
			sda_in <= slaveaddr_w(i+1);
			
			wait for cycle*5;
			scl <= '1';
			
			wait for cycle*10;
			scl <= '0';
		end loop;
		
		wait for cycle*5;
		sda_in <= '0';
		
		wait for cycle*5;
		scl <= '1';
		
		wait for cycle*10;
		scl <= '0';

		--*********************
		-- Send register address
		--*********************
		for i in 0 to 7 loop		
		wait for cycle*5;
			sda_in <= i2cregaddr_00(i+1);
			
			wait for cycle*5;
			scl <= '1';
			
			wait for cycle*10;
			scl <= '0';
		end loop;
		
		--*************************
		--repeated START condition
		--*************************
		wait for cycle*5;
		sda_in <= '1';
		
		wait for cycle*5;
		scl <= '1';
		
		wait for cycle*5;
		sda_in <= '0';
				
		wait for cycle*5;
		scl <= '0';

		wait for cycle*5;
		sda_in <= '1';
		
		wait for cycle*5;
		scl <= '1';
		
		wait for cycle*5;
		sda_in <= '0';
				
		wait for cycle*5;
		scl <= '0';
		
		--*************************
		-- Send slave address(read)
		--*************************
		for i in 0 to 7 loop		
		wait for cycle*5;
			sda_in <= slaveaddr_r(i+1);
			
			wait for cycle*5;
			scl <= '1';
			
			wait for cycle*10;
			scl <= '0';
		end loop;
		
		wait for cycle*5;
		sda_in <= '0';
		
		wait for cycle*5;
		scl <= '1';
		
		wait for cycle*10;
		scl <= '0';
		
		--***************************
		--SCL for read data transfer
		--***************************
		for i in 0 to 8 loop
			wait for cycle*10;
			scl <= '1';
			wait for cycle*10;
			scl <= '0';
		end loop;
		
		--****************
		-- STOP confition
		--****************
		wait for cycle*10;
		scl <= '1';
		
		wait for cycle*5;
		sda_in <= '1';
		
		wait for cycle*10;
		scl <= '1';		
		
		wait;
	end PROCESS;
	
end sim;

CONFIGURATION i2c_slave_top_test of testbench_i2c_slave_top IS
	for sim
	end for;
end i2c_slave_top_test;