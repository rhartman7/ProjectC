library IEEE;
--use work.2darray.all;
use IEEE.std_logic_1164.all;
use work.all;

entity barrel_shifter_32 is
	
  	port(
		a_in  : in std_logic_vector(31 downto 0);
		sel : in std_logic_vector(4 downto 0);
		sel_srl_sll : in std_logic;
		sel_srl_sra : in std_logic;
		output 	: out std_logic_vector(31 downto 0));
end barrel_shifter_32;



architecture structure of barrel_shifter_32 is 


component mux_21
  	port(i_X  : in std_logic;
		i_Y: in std_logic;
		s_1 : in std_logic;
		o_Z : out std_logic);
end component;

component mux_21_n
	generic(N : integer := 32);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component bit_reversal
  	port(	input  : in std_logic_vector( 31 downto 0);
		output : out std_logic_vector(31 downto 0));
end component;



signal s_first_column, s_second_column, s_third_column, s_fourth_column, s_bit_reversal_out, s_bit_reversal, s_final_output, s_output_reversal, s_output  :	std_logic_vector(31 downto 0);
signal s_srl_sra : std_logic;
begin

reversal : bit_reversal
	port MAP(
		input => a_in,
		output => s_bit_reversal);

mux_21_srl_sll: mux_21_n
	port MAP(
	i_X => a_in,
	i_Y => s_bit_reversal,
	s_1 => sel_srl_sll,
	o_Z => s_bit_reversal_out);


mux_21_sra_srl: mux_21
	port MAP(
	i_X => '0',
	i_Y => a_in(31),
	s_1 => sel_srl_sra,
	o_Z => s_srl_sra);

mux_21_first_column: for i in 0 to 30 generate
mux_21_1: mux_21
	port MAP(
	i_X => s_bit_reversal_out(i),
	i_Y => s_bit_reversal_out(i+1),
	s_1 => sel(0),
	o_Z => s_first_column(i));
end generate;

mux_21_1_a: mux_21
	port MAP(
	i_X => s_bit_reversal_out(31),
	i_Y => s_srl_sra,
	s_1 => sel(0),
	o_Z => s_first_column(31));

mux_21_second_column: for i in 0 to 29 generate
mux_21_2: mux_21
	port MAP(
	i_X => s_first_column(i),
	i_Y => s_first_column(i+2),
	s_1 => sel(1),
	o_Z => s_second_column(i));
end generate;

mux_21_2_a: mux_21
	port MAP(
	i_X => s_first_column(30),
	i_Y => s_srl_sra,
	s_1 => sel(1),
	o_Z => s_second_column(30));

mux_21_2_b: mux_21
	port MAP(
	i_X => s_first_column(31),
	i_Y => s_srl_sra,
	s_1 => sel(1),
	o_Z => s_second_column(31));



mux_21_third_column: for i in 0 to 27 generate
mux_21_3: mux_21
	port MAP(
	i_X => s_second_column(i),
	i_Y => s_second_column(i+4),
	s_1 => sel(2),
	o_Z => s_third_column(i));
end generate;

mux_21_third_column_shift: for i in 28 to 31 generate
mux_21_3_a: mux_21
	port MAP(
	i_X => s_second_column(i),
	i_Y => s_srl_sra,
	s_1 => sel(2),
	o_Z => s_third_column(i));
end generate;

mux_21_fourth_column: for i in 0 to 23 generate
mux_21_4: mux_21
	port MAP(
	i_X => s_third_column(i),
	i_Y => s_third_column(i+8),
	s_1 => sel(3),
	o_Z => s_fourth_column(i));
end generate;
mux_21_fourth_column_shift: for i in 24 to 31 generate
mux_21_4_a_1: mux_21
	port MAP(
	i_X => s_third_column(i),
	i_Y => s_srl_sra,
	s_1 => sel(3),
	o_Z => s_fourth_column(i));
end generate;

mux_21_fifth_column: for i in 0 to 15 generate
mux_21_5: mux_21
	port MAP(
	i_X => s_fourth_column(i),
	i_Y => s_fourth_column(i+16),
	s_1 => sel(4),
	o_Z => s_output(i));
end generate;

mux_21_fifth_column_shift_in: for i in 16 to 31 generate
mux_21_5_a: mux_21
	port MAP(
	i_X => s_fourth_column(i),
	i_Y => s_srl_sra,
	s_1 => sel(4),
	o_Z => s_output(i));
end generate;

reversal_2 : bit_reversal
	port MAP(
		input => s_output,
		output => s_output_reversal);

 
mux_21_srl_sll_2: mux_21_n
	port MAP(
	i_X => s_output,
	i_Y => s_output_reversal,
	s_1 => sel_srl_sll,
	o_Z => s_final_output);

output <= s_final_output;


end structure;



