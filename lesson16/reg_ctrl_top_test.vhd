library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity testbench_reg_ctrl_top is
end testbench_reg_ctrl_top;

architecture sim of testbench_reg_ctrl_top is

component reg_ctrl_top
port(
  reset 	: in std_logic;
  clock	: in std_logic;
  scl_in : in std_logic;
  sda_in : in std_logic;
  dipsw1 : in std_logic_vector(7 downto 0);
  dipsw2 : in std_logic_vector(7 downto 0);
  led : out std_logic_vector(7 downto 0);
  acc_reg1: out std_logic_vector(7 downto 0);
  acc_reg2: out std_logic_vector(7 downto 0);
  acc_reg3: out std_logic_vector(7 downto 0);
  motor: out std_logic_vector(7 downto 0);
  selmap : out std_logic_vector(7 downto 0)
);
end component;
	
constant cycle	: Time := 25ns;
constant	half_cycle : Time := 12.5ns;
constant i,j : integer := 0;

type BYTE_DATA is array(1 to 8) of std_logic;
constant slaveaddr_w : BYTE_DATA := ('1','0','1','0','0','1','0','0');
constant slaveaddr_r : BYTE_DATA := ('1','0','1','0','0','1','0','1');
--constant i2cregaddr_00 : BYTE_DATA := ('0','0','0','0','0','0','0','0');
--constant i2cregdata_55 : BYTE_DATA := ('0','1','0','1','0','1','0','1');
--constant i2cregdata_AA : BYTE_DATA := ('1','0','1','0','1','0','1','0');
--
--type REGARRAY is array(0 to 7,0 to 7) of std_logic;
--constant data_patarn : REGARRAY := (('0','0','0','0','0','0','0','0'), -- 0 X"00"
--                                    ('1','1','1','1','1','1','1','1'), -- 1 X"FF"
--                                    ('0','1','0','1','0','1','0','1'), -- 2 X"55"
--                                    ('1','0','1','0','1','0','1','0'), -- 3 X"AA"
--                                    ('1','1','0','0','1','1','0','0'), -- 4 X"EE"
--                                    ('0','0','1','1','0','0','1','1'), -- 5 X"33"
--                                    ('1','1','1','1','0','0','0','0'), -- 6 X"F0"
--                                    ('0','0','0','0','1','1','1','1')   --7 X"0F
--                                   );
--constant reg_address : REGARRAY := (('0','0','0','0','0','0','0','0'), -- 0 X"00"
--                                    ('0','0','0','0','0','0','0','1'), -- 1 X"01"
--                                    ('0','0','0','0','0','0','1','0'), -- 2 X"02"
--                                    ('0','0','0','0','0','0','1','1'), -- 3 X"03"
--                                    ('0','0','0','0','0','1','0','0'), -- 4 X"04"
--                                    ('0','0','0','0','0','1','0','1'), -- 5 X"05"
--                                    ('0','0','0','0','0','1','1','0'), -- 6 X"06"
--                                    ('0','0','0','0','0','1','1','1')   --7 X"07"
--                                   );

signal reset,clk,ready,scl_in,sda_in : std_logic;
signal start,stop,r_w,data_vld,scl_oe,sda_oe : std_logic;
signal selmap : std_logic_vector(7 downto 0);
signal dipsw1,dipsw2,acc_reg1,acc_reg2,acc_reg3 : std_logic_vector(7 downto 0);
signal motor,led : std_logic_vector(7 downto 0);
signal data_in,data_out,reg_addr,send_data : std_logic_vector(7 downto 0);

  --=======================
  -- I2C Register Write
  --=======================
  procedure i2c_regWrite(
    signal scl_o : out std_logic;
    signal sda_o : out std_logic;
    signal reg_addr : in std_logic_vector(7 downto 0);
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
    sda_o <= '0';
		
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
    sda_o <= '0'; -- ACK
		
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
	 sda_o <= '1';

--    wait for scl_period / 2;
--    scl_o <= '0';
--		
--    wait for scl_period;
--    scl_o <= '1';
	 
    wait for 10 us;
	 
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
		
    --************************
    -- Not aknowledge from master
    --************************
    wait for scl_period / 2;
    sda_o <= '1';
		
    wait for scl_period / 2;
    scl_o <= '1';
		
    wait for scl_period;
    scl_o <= '0';

    wait for scl_period / 2;
    sda_o <= '0';
	 
    --****************
    -- STOP confition
    --****************
    wait for scl_period;
    scl_o <= '1';

	 wait for scl_period / 2;
	 sda_o <= '1';

  end procedure;

begin
  U1: reg_ctrl_top port map (reset=>reset,clock=>clk,scl_in=>scl_in,sda_in=>sda_in,dipsw1=>dipsw1,
                             dipsw2=>dipsw2,led=>led,acc_reg1=>acc_reg1,acc_reg2=>acc_reg2,
                             acc_reg3=>acc_reg3,motor=>motor,selmap=>selmap);
	 
  process begin
    clk <= '0';
    wait for half_cycle;
    clk <= '1';
    wait for half_cycle;
  end process;
		
  process begin
    reset <= '0';
    scl_in <= '1';
    sda_in <= '1';
    ready <= '1';
    dipsw1 <= "00001111";
    dipsw2 <= "01110000";
		
    wait for cycle*100;
    reset <= '1';

--    reg_addr <= "00000001";
--    i2c_regRead(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr);
--    wait for 100 us;
--    reg_addr <= "00000000";
--    i2c_regRead(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr);
--    wait for 100 us;

    reg_addr <= "00000011";
    send_data <= "10101010";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
    reg_addr <= "00000100";
    send_data <= "01010101";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
    reg_addr <= "00000101";
    send_data <= "11001100";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
    reg_addr <= "00000001";
    i2c_regRead(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr);
    wait for 100 us;
    reg_addr <= "00000000";
    i2c_regRead(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr);
    wait for 100 us;

    reg_addr <= "00000010";
    send_data <= "00001111";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
    reg_addr <= "00000111";
    send_data <= "00000011";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);
    wait for 50 us;
		
    reg_addr <= "00000110";
    send_data <= "01011010";
    i2c_regWrite(scl_o => scl_in, sda_o => sda_in, reg_addr => reg_addr, data => send_data);

    wait;
  end process;	
end sim;

configuration reg_ctrl_top_test of testbench_reg_ctrl_top is
	for sim
	end for;
end reg_ctrl_top_test;