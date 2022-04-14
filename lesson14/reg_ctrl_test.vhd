Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY reg_ctrl_test IS
END reg_ctrl_test;

ARCHITECTURE reg_ctrl_test_bench OF reg_ctrl_test IS

COMPONENT reg_ctrl
PORT(
 reset  : in  std_logic;                     	-- System Reset
 sysclk	: in std_logic;
 start   : in std_logic;                     	-- start of the i2c cycle
 stop    : in std_logic;                     	-- stop the i2c cycle
 r_w     : in std_logic;                     	-- read/write signal to the reg_map bloc
 data_vld: in std_logic;                     	-- data valid from i2c
 data_in : in  std_logic_vector(7 DOWNTO 0);  	-- parallel data in
 ready   : out  std_logic;                     	-- back end system ready signal
 data_out: out std_logic_vector(7 DOWNTO 0)  	-- parallel data out
);
END COMPONENT;
	
constant cycle	: Time := 100ns;
constant	half_cycle : Time := 50ns;
constant i : integer := 0;

signal reset,clk,start,stop,r_w,data_vld : std_logic;
signal data_in : std_logic_vector(7 downto 0);
signal scl : std_logic;

BEGIN

	U1: reg_ctrl port map (reset=>reset,sysclk=>clk,start=>start,stop=>stop,r_w=>r_w,data_vld=>data_vld,
									data_in=>data_in);
	 
	PROCESS BEGIN
		clk <= '0';
		wait for half_cycle;
		clk <= '1';
		wait for half_cycle;
	end PROCESS;
	
	PROCESS BEGIN
		reset <= '1';
		start <= '0';
		stop <= '0';
		r_w <= '0';
		data_vld <= '0';
		data_in <= "00000000";
		
		wait for cycle*10;
		reset <= '0';
		
		--***********************
		-- Seacential write/read
		--***********************
		for i in 0 to 2 loop
			wait for cycle*100;
			data_vld <= '1';
			
			wait for cycle*10;
			data_vld <= '0';
			
			if i = 0 then
				data_in <= "01011010";
			elsif i = 1 then
				data_in <= "10100101";
			elsif i = 2 then
				data_in <= "00101101";
			end if;
		end loop;
		
		wait for cycle*2;
		stop <= '1';
		wait for cycle*10;
		stop <= '0';
		
		wait for cycle*10;
		r_w <= '1';
		data_in <= "00000000";
		
		for i in 0 to 3 loop
			wait for cycle*100;
			data_vld <= '1';
			
			wait for cycle*10;
			data_vld <= '0';
		end loop;			
		
		wait for cycle*2;
		stop <= '1';
		wait for cycle*10;
		stop <= '0';

		--*******************
		--	Single write/read	
		--*******************
		wait for cycle*10;
		r_w <= '0';

		for i in 0 to 1 loop
			if i = 0 then
				data_in <= "00000000";
			elsif i = 1 then
				data_in <= "01010101";
			end if;
			wait for cycle*100;
			data_vld <= '1';
			wait for cycle*10;
			data_vld <= '0';
		end loop;

		wait for cycle*2;
		stop <= '1';
		wait for cycle*10;
		stop <= '0';
		
		wait for cycle*10;
		r_w <= '1';
		
		for i in 0 to 1 loop
			if i = 0 then
				data_in <= "00000000";
			end if;
			wait for cycle*100;
			data_vld <= '1';
			wait for cycle*10;
			data_vld <= '0';
		end loop;
	
		wait for cycle*2;
		stop <= '1';
		wait for cycle*10;
		stop <= '0';

		wait;
	end PROCESS;
	
end reg_ctrl_test_bench;

CONFIGURATION cfg_test of reg_ctrl_test IS
	for reg_ctrl_test_bench
	end for;
end cfg_test;