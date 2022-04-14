library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;

entity reg_ctrl is
port(
  reset : in std_logic;
  clock : in std_logic;
  start : in std_logic;
  stop : in std_logic;
  r_w : in std_logic;
  sda_oe : in std_logic;
  data_vld : in std_logic;
  data_i : in  std_logic_vector(7 downto 0);
  ready : out  std_logic;
  data_o : out std_logic_vector(7 downto 0); 
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

  signal dstop,dr_w : std_logic;
  signal fdata_vld : std_logic;
  signal addr_reg : std_logic_vector(2 downto 0);
  signal dreg,ddreg,dddreg : std_logic_vector(3 downto 0);
  signal in_reg,out_reg : std_logic_vector(7 downto 0);
  signal ddata_i,dddata_i,ddddata_i : std_logic_vector(7 downto 0);

  type states is (idle,address_w,data_r,data_w);
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
      dddreg <= "0000";
    elsif(clock'event and clock='1') then
      dddreg <= ddreg;
      ddreg <= dreg;
    end if;
  end process;

  dstop <= ddreg(3);
  dr_w <= ddreg(1);

  process(clock,reset) begin
    if reset = '0' then
      ddata_i <= "00000000";
      dddata_i <= "00000000";
      ddddata_i <= "00000000";
    elsif(clock'event and clock='1') then
      ddata_i <= data_i;
      dddata_i <= ddata_i;
      ddddata_i <= dddata_i;
    end if;
  end process;

  ----------------------
  -- Detect egde
  ----------------------
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

  STATE_MACHINE:
  process(present_state,dstop,fdata_vld,dr_w) begin
    case present_state is
      when idle =>
        if fdata_vld = '1' then
          next_state <= address_w;
        else
          next_state <= present_state;
        end if;
      when address_w =>
        if dr_w = '1' then
          next_state <= data_r;
        elsif fdata_vld = '1' then
          next_state <= data_w;
        else
          next_state <= present_state;
        end if;
      when data_r =>
        if dstop = '1' then
          next_state <= idle;
        else
          next_state <= present_state;
        end if;
      when data_w =>
        if dstop = '1' then
          next_state <= idle;
        else
          next_state <= present_state;
        end if;
      when others =>
        next_state <= idle;
    end case;
  end process STATE_MACHINE;

DATA_PATH:
  process(clock,reset) begin
    if(reset = '0') then
      in_reg <= "00000000";
      data_o <= "00000000";
      addr_reg <= "000";
    elsif (clock'event and clock='1') then
      if(present_state = address_w) then
        addr_reg <= ddddata_i( 2 downto 0);
      elsif(present_state = data_r) then
        data_o <= out_reg;
      elsif(present_state = data_w) then
        in_reg <= ddddata_i;
      end if;
    end if;	
  end process DATA_PATH;

  -----------
  -- Register
  -----------
  process(clock,reset) begin
    if(reset = '0') then
      out_reg <= "00000000";
    elsif (clock'event and clock = '1') then
      if (present_state = data_r) then
        case addr_reg is
          when "000" =>
            out_reg <= dipsw1;
          when "001" =>
            out_reg <= dipsw2;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  process(clock) begin
    if(clock'event and clock='1') then
      if (present_state = data_w) then
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
            selmap <= in_reg;
          when others => null;
        end case;
      end if;
    end if;
  end process;

  ready <= '1';

end rtl;

