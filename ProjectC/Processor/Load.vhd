library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity load is
	port(	
		in_memory  : in std_logic_vector(31 downto 0);
		load_which_load : in std_logic_vector(1 downto 0);
		load_type_sign : in std_logic;
		load_alu_out : in std_logic_vector(1 downto 0);
		out_load: out std_logic_vector(31 downto 0));
end load;

architecture structure of load is 


component mux_21_n
	generic(N : integer := 32);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component mux_21_16_bit
	generic(N : integer := 16);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component mux_21_5_bit
	generic(N : integer := 5);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;



component extender_8
  	port(
		extend_in  : in std_logic_vector(7 downto 0);
		sign_sel  : in std_logic;
		extend_out  : out std_logic_vector(31 downto 0));
end component;

component extender_16 
  	port(
		extend_in  : in std_logic_vector(15 downto 0);
		sign_sel  : in std_logic;
		extend_out  : out std_logic_vector(31 downto 0));
end component;

component mux_4_1_32
	generic(N : integer := 32);
  	port(	i_00  : in std_logic_vector(N-1 downto 0);
		i_01  : in std_logic_vector(N-1 downto 0);
		i_10  : in std_logic_vector(N-1 downto 0);
		i_11  : in std_logic_vector(N-1 downto 0);
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component mux_4_1_8
	generic(N : integer := 8);
  	port(	i_00  : in std_logic_vector(N-1 downto 0);
		i_01  : in std_logic_vector(N-1 downto 0);
		i_10  : in std_logic_vector(N-1 downto 0);
		i_11  : in std_logic_vector(N-1 downto 0);
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic_vector(N-1 downto 0));
end component;



signal s_extend_s_32_h, s_extend_un_32_h, s_half_out, s_extend_s_32_b, s_extend_un_32_b, s_byte_out: std_logic_vector(31 downto 0);
signal s_which_half_out: std_logic_vector(15 downto 0);
signal s_mux_4_1_8_out: std_logic_vector(7 downto 0);

begin

half_word_21_mux : mux_21_16_bit
	port MAP(i_X  =>in_memory(31 downto 16),
		i_Y =>in_memory(15 downto 0),
		s_1 =>load_alu_out(1),
		o_Z => s_which_half_out);


extender_16_a : extender_16
	port MAP(
		extend_in =>s_which_half_out,
		sign_sel =>'0',
		extend_out  =>s_extend_un_32_h);

extender_16_b : extender_16
	port MAP(
		extend_in => s_which_half_out,
		sign_sel =>'1',
		extend_out  =>s_extend_s_32_h);

load_half_word_21_mux : mux_21_n
	port MAP(i_X  =>s_extend_s_32_h,
		i_Y =>s_extend_un_32_h,
		s_1 =>load_type_sign,
		o_Z => s_half_out);

mux_4_1_8_mem_out : mux_4_1_8
port MAP(	i_00 =>in_memory(31 downto 24),
		i_01 =>in_memory(23 downto 16),
		i_10 =>in_memory(15 downto 8),
		i_11 =>in_memory(7 downto 0),
		sel =>load_alu_out,
		o_Z  =>s_mux_4_1_8_out);

extender_8_a : extender_8
	port MAP(
		extend_in  => s_mux_4_1_8_out,
		sign_sel  => '0',
		extend_out  =>s_extend_un_32_b);

extender_8_b : extender_8
	port MAP(
		extend_in  => s_mux_4_1_8_out,
		sign_sel  =>'1',
		extend_out  =>s_extend_s_32_b);

load_byte_21_mux : mux_21_n
	port MAP(i_X  =>s_extend_s_32_b,
		i_Y =>s_extend_un_32_b,
		s_1 =>load_type_sign,
		o_Z => s_byte_out);


mux_41 : mux_4_1_32
port MAP(	i_00 =>in_memory,
		i_01 =>s_byte_out,
		i_10 =>s_half_out,
		i_11 =>x"00000000",
		sel =>load_which_load,
		o_Z =>out_load);


end structure;