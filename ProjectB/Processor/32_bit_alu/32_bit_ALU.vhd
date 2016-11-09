library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity ALU_32_bit is
  	port(
		a_in  : in std_logic_vector(31 downto 0);
		b_in 	: in std_logic_vector(31 downto 0);
		op 	: in std_logic_vector(2 downto 0);
		add_sub : in std_logic;
		load_type : in std_logic;
		result_out : out std_logic_vector(31 downto 0);
		overflow : out std_logic;
		zero_out : out std_logic;
		c_out 	: out std_logic);
end ALU_32_bit;



architecture structure of ALU_32_bit is 

component overflow_detection
  	port(
		a_in  : in std_logic;
		b_in 	: in std_logic;
		sum_in 	: in std_logic;
		load_type : in std_logic;
		c_in	: in std_logic;
		overflow_out : out std_logic);
end component;

component ones_complement_data
	generic(N : integer := 32);
  	port(i_A  : in std_logic_vector(N-1 downto 0);
		o_F : out std_logic_vector(N-1 downto 0));
end component;


component OneBitALU
  
  port(
    operation     :     in std_logic_vector(2 downto 0);
    a_input       :     in  std_logic;
    b_input       :     in  std_logic;
    c_in          :     in  std_logic;
    less          :     in  std_logic;
    result        :     out std_logic;
    sum           :     out std_logic;
    c_out         :     out std_logic);
    
end component;


component mux_21_n
	generic(N : integer := 32);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;



signal s_b_out, s_b_in_not, s_result_out: std_logic_vector(31 downto 0);
signal s_cout_0, s_cout_1, s_cout_2, s_cout_3, s_cout_4,s_cout_5, s_cout_6, s_cout_7, s_cout_8, s_cout_9, s_cout_10  : std_logic;
signal s_cout_11, s_cout_12, s_cout_13, s_cout_14,s_cout_15, s_cout_16, s_cout_17, s_cout_18, s_cout_19, s_cout_20  : std_logic;
signal s_cout_21, s_cout_22, s_cout_23, s_cout_24,s_cout_25, s_cout_26, s_cout_27, s_cout_28, s_cout_29, s_cout_30, s_cout_31, s_sum_out_31_not  : std_logic;
signal s_sum_out_31 : std_logic;
begin

ones_comp: ones_complement_data
	port MAP(
		i_A => b_in,
		o_F => s_b_in_not);

mux_21_b_output: mux_21_n
	port MAP(
	i_X => b_in,
	i_Y => s_b_in_not,
	s_1 => add_sub,
	o_Z => s_b_out);

s_sum_out_31_not <= not(s_sum_out_31);
one_bit_alu_0 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(0),
    	b_input=> s_b_out(0),
    	c_in=> add_sub,
    	less=> s_sum_out_31_not,
    	result=> s_result_out(0),
    	c_out => s_cout_0);

one_bit_alu_1 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(1),
    	b_input=> s_b_out(1),
    	c_in=> s_cout_0,
    	less=> '0',
    	result=> s_result_out(1),
    	c_out => s_cout_1);

one_bit_alu_2 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(2),
    	b_input=> s_b_out(2),
    	c_in=> s_cout_1,
    	less=> '0',
    	result=> s_result_out(2),
    	c_out => s_cout_2);

one_bit_alu_3 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(3),
    	b_input=> s_b_out(3),
    	c_in=> s_cout_2,
    	less=> '0',
    	result=> s_result_out(3),
    	c_out => s_cout_3);

one_bit_alu_4 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(4),
    	b_input=> s_b_out(4),
    	c_in=> s_cout_3,
    	less=> '0',
    	result=> s_result_out(4),
    	c_out => s_cout_4);
one_bit_alu_5 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(5),
    	b_input=> s_b_out(5),
    	c_in=> s_cout_4,
    	less=> '0',
    	result=> s_result_out(5),
    	c_out => s_cout_5);
one_bit_alu_6 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(6),
    	b_input=> s_b_out(6),
    	c_in=> s_cout_5,
    	less=> '0',
    	result=> s_result_out(6),
    	c_out => s_cout_6);
one_bit_alu_7 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(7),
    	b_input=> s_b_out(7),
    	c_in=> s_cout_6,
    	less=> '0',
    	result=> s_result_out(7),
    	c_out => s_cout_7);
one_bit_alu_8 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(8),
    	b_input=> s_b_out(8),
    	c_in=> s_cout_7,
    	less=> '0',
    	result=> s_result_out(8),
    	c_out => s_cout_8);
one_bit_alu_9 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(9),
    	b_input=> s_b_out(9),
    	c_in=> s_cout_8,
    	less=> '0',
    	result=> s_result_out(9),
    	c_out => s_cout_9);
one_bit_alu_10 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(10),
    	b_input=> s_b_out(10),
    	c_in=> s_cout_9,
    	less=> '0',
    	result=> s_result_out(10),
    	c_out => s_cout_10);
one_bit_alu_11 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(11),
    	b_input=> s_b_out(11),
    	c_in=> s_cout_10,
    	less=> '0',
    	result=> s_result_out(11),
    	c_out => s_cout_11);
one_bit_alu_12 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(12),
    	b_input=> s_b_out(12),
    	c_in=> s_cout_11,
    	less=> '0',
    	result=> s_result_out(12),
    	c_out => s_cout_12);
one_bit_alu_13 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(13),
    	b_input=> s_b_out(13),
    	c_in=> s_cout_12,
    	less=> '0',
    	result=> s_result_out(13),
    	c_out => s_cout_13);
one_bit_alu_14 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(14),
    	b_input=> s_b_out(14),
    	c_in=> s_cout_13,
    	less=> '0',
    	result=> s_result_out(14),
    	c_out => s_cout_14);
one_bit_alu_15 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(15),
    	b_input=> s_b_out(15),
    	c_in=> s_cout_14,
    	less=> '0',
    	result=> s_result_out(15),
    	c_out => s_cout_15);
one_bit_alu_16 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(16),
    	b_input=> s_b_out(16),
    	c_in=> s_cout_15,
    	less=> '0',
    	result=> s_result_out(16),
    	c_out => s_cout_16);
one_bit_alu_17 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(17),
    	b_input=> s_b_out(17),
    	c_in=> s_cout_16,
    	less=> '0',
    	result=> s_result_out(17),
    	c_out => s_cout_17);
one_bit_alu_18 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(18),
    	b_input=> s_b_out(18),
    	c_in=> s_cout_17,
    	less=> '0',
    	result=> s_result_out(18),
    	c_out => s_cout_18);
one_bit_alu_19 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(19),
    	b_input=> s_b_out(19),
    	c_in=> s_cout_18,
    	less=> '0',
    	result=> s_result_out(19),
    	c_out => s_cout_19);
one_bit_alu_20 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(20),
    	b_input=> s_b_out(20),
    	c_in=> s_cout_19,
    	less=> '0',
    	result=> s_result_out(20),
    	c_out => s_cout_20);
one_bit_alu_21 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(21),
    	b_input=> s_b_out(21),
    	c_in=> s_cout_20,
    	less=>'0',
    	result=> s_result_out(21),
    	c_out => s_cout_21);
one_bit_alu_22 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(22),
    	b_input=> s_b_out(22),
    	c_in=> s_cout_21,
    	less=> '0',
    	result=> s_result_out(22),
    	c_out => s_cout_22);
one_bit_alu_23 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(23),
    	b_input=> s_b_out(23),
    	c_in=> s_cout_22,
    	less=> '0',
    	result=> s_result_out(23),
    	c_out => s_cout_23);
one_bit_alu_24 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(24),
    	b_input=> s_b_out(24),
    	c_in=> s_cout_23,
    	less=> '0',
    	result=> s_result_out(24),
    	c_out => s_cout_24);
one_bit_alu_25 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(25),
    	b_input=> s_b_out(25),
    	c_in=> s_cout_24,
    	less=> '0',
    	result=> s_result_out(25),
    	c_out => s_cout_25);
one_bit_alu_26 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(26),
    	b_input=> s_b_out(26),
    	c_in=> s_cout_25,
    	less=> '0',
    	result=> s_result_out(26),
    	c_out => s_cout_26);
one_bit_alu_27 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(27),
    	b_input=> s_b_out(27),
    	c_in=> s_cout_26,
    	less=> '0',
    	result=> s_result_out(27),
    	c_out => s_cout_27);
one_bit_alu_28 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(28),
    	b_input=> s_b_out(28),
    	c_in=> s_cout_27,
    	less=> '0',
    	result=> s_result_out(28),
    	c_out => s_cout_28);
one_bit_alu_29 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(29),
    	b_input=> s_b_out(29),
    	c_in=> s_cout_28,
    	less=> '0',
    	result=> s_result_out(29),
    	c_out => s_cout_29);
one_bit_alu_30 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(30),
    	b_input=> s_b_out(30),
    	c_in=> s_cout_29,
    	less=> '0',
    	result=> s_result_out(30),
    	c_out => s_cout_30);
one_bit_alu_31 : OneBitALU
	port MAP(   
	operation => op,
    	a_input=> a_in(31),
    	b_input=> s_b_out(31),
    	c_in=> s_cout_30,
	sum => s_sum_out_31,
    	less=> '0',
    	result=> s_result_out(31),
    	c_out => s_cout_31);

overflow_detection_1: overflow_detection
  	port MAP(
		a_in => a_in(31),
		b_in =>s_b_out(31),
		sum_in 	=> s_sum_out_31,
		load_type=> load_type,
		c_in	=>s_cout_31,
		overflow_out =>overflow);

c_out <= s_cout_31;
result_out <= s_result_out;
zero_out <= s_result_out(0) xor s_result_out(1) xor s_result_out(2) xor s_result_out(3) xor s_result_out(4) xor s_result_out(5) xor s_result_out(6) xor s_result_out(7) xor s_result_out(8) xor s_result_out(9) xor s_result_out(10) xor s_result_out(11) xor s_result_out(12) xor s_result_out(13) xor s_result_out(14) xor s_result_out(15) xor s_result_out(16) xor s_result_out(17) xor s_result_out(18) xor s_result_out(19) xor s_result_out(20) xor s_result_out(21) xor s_result_out(22) xor s_result_out(23) xor s_result_out(24) xor s_result_out(25) xor s_result_out(26) xor s_result_out(27) xor s_result_out(28) xor s_result_out(29) xor s_result_out(30) xor s_result_out(31) ;

end structure;



