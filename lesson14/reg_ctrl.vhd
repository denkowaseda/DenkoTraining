Library IEEE;
USE IEEE.std_logic_1164.ALL;
USE WORK.ALL;
USE IEEE.std_logic_unsigned.ALL;

ENTITY reg_ctrl IS
PORT(
 reset 	: in  std_logic;                     	-- System Reset
 sysclk	: in std_logic;
 start   : in std_logic;                     	-- start of the i2c cycle
 stop    : in std_logic;                     	-- stop the i2c cycle
 r_w     : in std_logic;                     	-- read/write signal to the reg_map bloc
 data_vld	: in std_logic;                     	-- data valid from i2c
 data_in : in  std_logic_vector(7 DOWNTO 0);  	-- parallel data in
 ready   : out  std_logic;                     	-- back end system ready signal
 data_out	: out std_logic_vector(7 DOWNTO 0);  	-- parallel data out
 gpioen		: out std_logic_vector(7 downto 0);
 clk_conf	: out std_logic_vector(7 downto 0);
 mclk_div1	: out std_logic_vector(7 downto 0);
 mclk_div2	: out std_logic_vector(7 downto 0);
 fs_speed	: out std_logic_vector(7 downto 0);
 i2s_conf1	: out std_logic_vector(7 downto 0);
 i2s_conf2	: out std_logic_vector(7 downto 0);
 gpio1	: out std_logic_vector(7 downto 0)
);
END reg_ctrl;

ARCHITECTURE RTL OF reg_ctrl IS

	signal dstart,dstop,ddata_vld,dr_w,rd : std_logic;
	signal addr_reg : std_logic_vector(2 downto 0);
	signal dreg : std_logic_vector(3 downto 0);
	signal ddreg : std_logic_vector(3 downto 0);
	signal dddreg : std_logic_vector(3 downto 0);
--	signal addr_reg : std_logic_vector(6 downto 0);
	signal gpio_en : std_logic_vector(7 downto 0) := "00001111";
	signal bclk_lrck_conf : std_logic_vector(7 downto 0) := "00100000";
	signal master_clkdiv1 : std_logic_vector(7 downto 0) := "00001111";
	signal master_clkdiv2 : std_logic_vector(7 downto 0) := "11110000";
	signal fs_speed_mode	: std_logic_vector(7 downto 0) := "00000000";
	signal i2s_format1 : std_logic_vector(7 downto 0) := "00000000";
	signal i2s_format2 : std_logic_vector(7 downto 0) := "00000000";
	signal gpin_out : std_logic_vector(7 downto 0) := "11111111";

	type states IS (idle,address,data);
	signal present_state: states;
	signal next_state: states;

begin
	----------------------
	-- Protect meta-stable
	----------------------
	process(sysclk,reset) begin
		if reset = '1' then
			dreg <= "0000";
		elsif(sysclk'event and sysclk = '1') then
			dreg(3) <= start;
			dreg(2) <= stop;
			dreg(1) <= r_w;
			dreg(0) <= data_vld;
		end if;
	end process;
	
	process(sysclk,reset) begin
		if reset = '1' then
			ddreg <= "0000";
		elsif (sysclk'event and sysclk = '1') then
			ddreg <= dreg;
		end if;
	end process;
	
	process(sysclk,reset) begin
		if reset = '1' then
			dddreg <= "0000";
		elsif (sysclk'event and sysclk = '1') then
			dddreg <= ddreg;
		end if;
	end process;
		
	dr_w <= ddreg(1);
	
	----------------------
	-- Detect rising egde
	----------------------
	dstart <= ddreg(3) and not dddreg(3);
	dstop <= ddreg(2) and not dddreg(2);
	rd <= ddreg(1) and not dddreg(1);
	ddata_vld <= ddreg(0) and not dddreg(0);


	-----------------
	-- State machine
	-----------------
	process(sysclk,reset) begin
		if (reset = '1') then
			present_state <= idle;
		elsif (sysclk'event and sysclk = '1') then
			present_state <= next_state;
		end if;
	end process;
	
	process(present_state,dstop,ddata_vld) begin
		case present_state is
			when idle =>
				if ddata_vld = '1' then
					next_state <= address;
				else
					next_state <= present_state;
				end if;
			when address =>
				if ddata_vld = '1' then
					next_state <= data;
				else
					next_state <= present_state;
				end if;
			when data =>
				if ddata_vld = '1' then
					next_state <= data;
				elsif dstop = '1' then
					next_state <= idle;
				else
					next_state <= present_state;
				end if;
		end case;
	end process;
		
	---------------------------
	-- Register address counter
	---------------------------
	process(sysclk) begin
		if (sysclk'event and sysclk = '1') then
			if ((present_state = address) and (dr_w = '0')) then
				addr_reg <= data_in(2 downto 0);
			elsif ((dr_w = '1') and (rd = '1')) then
				addr_reg <= data_in(2 downto 0);
			elsif ((present_state = address) or (present_state = data)) then
				if ddata_vld = '1' then
					if addr_reg = "111" then
						addr_reg <= addr_reg;
					else
						addr_reg <= addr_reg + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
		
	-----------
	-- Register
	-----------
	process(sysclk,addr_reg) begin
		if (sysclk'event and sysclk = '1') then
			if ((present_state = data) and (dr_w = '0')) then
				case addr_reg is
					when "000" =>
						gpio_en <= data_in;
					when "001" =>
						bclk_lrck_conf <= data_in;
					when "010" =>
						master_clkdiv1 <= data_in;
					when "011" =>
						master_clkdiv2 <= data_in;
					when "100" =>
						fs_speed_mode <= data_in;
					when "101" =>
						i2s_format1 <= data_in;
					when "110" =>
						i2s_format2 <= data_in;
					when "111" =>
						gpin_out <= data_in;
					when others => gpio_en <= data_in;
				end case;
			end if;
		end if;
	end process;
	
	process(sysclk,addr_reg) begin
		if (sysclk'event and sysclk = '1') then
			if (dr_w = '1') then
				if ((present_state = address) or (present_state = data)) then
					case addr_reg is
						when "000" =>
							data_out <= gpio_en;
						when "001" =>
							data_out <= bclk_lrck_conf;
						when "010" =>
							data_out <= master_clkdiv1;
						when "011" =>
							data_out <= master_clkdiv2;
						when "100" =>
							data_out <= fs_speed_mode;
						when "101" =>
							data_out <= i2s_format1;
						when "110" =>
							data_out <= i2s_format2;
						when "111" =>
							data_out <= gpin_out;
						when others => data_out <= "XXXXXXXX";
					end case;
				end if;		
			end if;					
		end if;
	end process;
		
	gpioen <= gpio_en;
	clk_conf <= bclk_lrck_conf;
	mclk_div1 <= master_clkdiv1;
	mclk_div2 <= master_clkdiv2;
	fs_speed <= fs_speed_mode;
	i2s_conf1 <= i2s_format1;
	i2s_conf2 <= i2s_format2;
	gpio1 <= gpin_out;
	
	ready <= '1';
	
end RTL;