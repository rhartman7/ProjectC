library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity store is
	port(	
		alu_in : in std_logic_vector(31 downto 0);
		reg_out_2_in : in std_logic_vector(31 downto 0);
		load_size : in std_logic_vector(1 downto 0);
		store_data: out std_logic_vector(31 downto 0);
		store_byteena: out std_logic_vector(3 downto 0));
end store;

architecture structure of store is 

component mux_4_1_32
	generic(N : integer := 32);
  	port(	i_00  : in std_logic_vector(N-1 downto 0);
		i_01  : in std_logic_vector(N-1 downto 0);
		i_10  : in std_logic_vector(N-1 downto 0);
		i_11  : in std_logic_vector(N-1 downto 0);
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic_vector(N-1 downto 0));
end component;


component mux_4_1_4
	generic(N : integer := 4);
  	port(	i_00  : in std_logic_vector(N-1 downto 0);
		i_01  : in std_logic_vector(N-1 downto 0);
		i_10  : in std_logic_vector(N-1 downto 0);
		i_11  : in std_logic_vector(N-1 downto 0);
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component mux_21_n 
	generic(N : integer := 4);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

signal s_repeated_bits_8, s_repeated_bits_16: std_logic_vector(31 downto 0);
signal s_store_half_out: std_logic_vector(3 downto 0);
signal s_store_byte_out,s_decoder_24_out_0, s_decoder_24_out_1, s_decoder_24_out_2, s_decoder_24_out_3 : std_logic_vector(3 downto 0);

begin

s_repeated_bits_8(31 downto 24) <= alu_in(7 downto 0);
s_repeated_bits_8(23 downto 16) <= alu_in(7 downto 0);
s_repeated_bits_8(15 downto 8) <= alu_in(7 downto 0);
s_repeated_bits_8(7 downto 0) <= alu_in(7 downto 0);

s_repeated_bits_16(31 downto 16) <= alu_in(15 downto 0);
s_repeated_bits_16(15 downto 0) <= alu_in(15 downto 0);

mux_41_mem_data : mux_4_1_32
port MAP(	i_00 =>reg_out_2_in,
		i_01 =>s_repeated_bits_8,
		i_10 => s_repeated_bits_16,
		i_11 =>x"00000000",
		sel =>load_size,
		o_Z =>store_data);


mux_41_mem_sb_byteena : mux_4_1_4
port MAP(	i_00 => "0001",
		i_01 =>"0010",
		i_10 =>"0100",
		i_11 =>"1000",
		sel =>alu_in(1 downto 0),
		o_Z =>s_store_byte_out);

mux_21_store_half: mux_21_n 
  	port MAP(i_X =>"0011",
		i_Y=>"1100",
		s_1=>alu_in(1),
		o_Z =>s_store_half_out);


mux_41_mem_byteena : mux_4_1_4
port MAP(	i_00 =>"1111",
		i_01 =>s_store_byte_out,
		i_10 =>s_store_half_out,
		i_11 =>"0000",
		sel =>load_size,
		o_Z =>store_byteena);

end structure;
