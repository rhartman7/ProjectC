library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity immediate is
	port(	
		in_immediate  : in std_logic_vector(15 downto 0);
		in_upper_byte : in std_logic_vector(15 downto 0);
		load_which_immediate : in std_logic;
		out_immediate: out std_logic_vector(31 downto 0));
end immediate;

architecture structure of immediate is 

component  extender_16 
  	port(
		extend_in  : in std_logic_vector(15 downto 0);
		sign_sel  : in std_logic;
		extend_out  : out std_logic_vector(31 downto 0));
end component;

component mux_21_n
	generic(N : integer := 32);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;



signal s_byte_extended, s_immediate_extended : std_logic_vector(31 downto 0);

begin

s_byte_extended <= (in_upper_byte & x"0000");

extend_in_immediate: extender_16 
  	port MAP(
		extend_in => in_immediate,
		sign_sel => '1',
		extend_out => s_immediate_extended);


immediate_21_mux : mux_21_n
	port MAP(
		i_X  =>s_immediate_extended,
		i_Y =>s_byte_extended,
		s_1 =>load_which_immediate,
		o_Z => out_immediate);




end structure;