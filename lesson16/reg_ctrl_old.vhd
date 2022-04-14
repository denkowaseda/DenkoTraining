library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity reg_ctrl IS
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
  led : out std_logic_vector(7 downto 0) := "00000000";
  acc_reg1 : out std_logic_vector(7 downto 0) := "00000000";
  acc_reg2 : out std_logic_vector(7 downto 0) := "00000000";
  acc_reg3 : out std_logic_vector(7 downto 0) := "00000000";
  motor : out std_logic_vector(7 downto 0) := "00000000";
  selmap : out std_logic_vector(7 downto 0) := "00000000"
);
end reg_ctrl;

architecture rtl of reg_ctrl is

  signal dstop,dr_w,dsda_oe : std_logic;
  signal rdata_vld,fdata_vld : std_logic;
  signal addr_reg : std_logic_vector(2 downto 0);
  signal dreg,ddreg,dddreg : std_logic_vector(3 downto 0);
  signal in_reg,out_reg : std_logic_vector(7 downto 0);
 
  type states IS (idle,address,address_w,d_read,d_write1,d_write2);
  signal present_state: states;
  signal next_state: states;

begin
  ----------------------
  -- Protect meta-stable
  ----------------------
  process(clock,reset) begin
    if reset = '0' then
      dreg <= "0000";
    elsif(clock'event and clock = '1') then
      dreg(3) <= stop;
      dreg(2) <= sda_oe;
      dreg(1) <= r_w;
      dreg(0) <= data_vld;	
    end if;
  end process;
	
	process(clock,reset) begin
		if reset = '0' then
			ddreg <= "0000";
		elsif (clock'event and clock = '1') then
			ddreg <= dreg;
		end if;
	end process;
	
	process(clock,reset) begin
		if reset = '0' then
			dddreg <= "0000";
		elsif (clock'event and clock = '1') then
			dddreg <= ddreg;
		end if;
	end process;

  dstop <= ddreg(3);
--  dsda_oe <= ddreg(2);
  dr_w <= ddreg(1);
--  ddata_vld <= ddreg(0);
	
	----------------------
	-- Detect egde
	----------------------
--	dstart <= ddreg(3) and not dddreg(3);
--	dstop <= ddreg(2) and not dddreg(2);
--	rd <= ddreg(1) and not dddreg(1);
  rdata_vld <= ddreg(0) and not dddreg(0);
  fdata_vld <= not ddreg(0) and dddreg(0);

	-----------------
	-- State machine
	-----------------
	process(clock,reset) begin
		if (reset = '0') then
			present_state <= idle;
		elsif (clock'event and clock = '1') then
			present_state <= next_state;
		end if;
	end process;
	
	process(present_state,dstop,rdata_vld,fdata_vld,dsda_oe,dr_w) begin
		case present_state is
			when idle =>
				if rdata_vld = '1' then
					next_state <= address;
				else
					next_state <= present_state;
				end if;
			when address =>
				if fdata_vld = '1' then
					next_state <= address_w;
				else
					next_state <= present_state;
				end if;
			when address_w =>
				if dr_w = '1' then
					next_state <= d_read;
				elsif rdata_vld = '1' then
					next_state <= d_write1;
				else
					next_state <= present_state;
				end if;
			when d_read =>
			  if dstop = '1' then
			    next_state <= idle;
			  else
			    next_state <= present_state;
			  end if;
			when d_write1 =>
			  if fdata_vld = '1' then
			    next_state <= d_write2;
			  else
			    next_state <= present_state;
			  end if;
			when d_write2 =>
			  if dstop = '1' then
			    next_state <= idle;
			  elsif dr_w = '1' then
			    next_state <= d_write1;
			  else
			    next_state <= present_state;
			  end if;
			when others =>
			  next_state <= idle;
		end case;
	end process;

  process(clock,reset) begin
    if(reset = '0') then
      in_reg <= "00000000";
      data_o <= "00000000";
      addr_reg <= "000";
    elsif (clock'event and clock='1') then
      in_reg <= data_i;
		data_o <= out_reg;
	   if(present_state = address_w) then
	     addr_reg <= in_reg( 2 downto 0);
	   elsif(present_state = d_read) then
	     data_o <= out_reg;
	   elsif(present_state = d_write2) then
	     in_reg <= data_i;
		end if;
	 end if;	
  end process;

	-----------
	-- Register
	-----------
  process(clock,addr_reg) begin
    if (clock'event and clock = '1') then
      if (present_state = d_read) then
	     case addr_reg is
          when "000" =>
            out_reg <= dipsw1;
          when "001" =>
            out_reg <= dipsw2;
--          when others => out_reg <= "XXXXXXXX";
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process(clock) begin
    if(clock'event and clock='1') then
      if (present_state = d_write2) then
        case addr_reg is
          when "010" =>
            led <= in_reg;
          when "011" =>
            acc_reg1 <= in_reg;
          when "100" =>
            acc_reg2 <= in_reg;
          when "101" =>
            acc_reg3 <= in_reg;
          when "110" =>
            motor <= in_reg;
          when "111" =>
            selmap <= in_reg(7 downto 0);
--          when others => led <= "XXXXXXXX";
          when others => null;
        end case;
      end if;
    end if;
  end process;

  ready <= '1';
	
end rtl;