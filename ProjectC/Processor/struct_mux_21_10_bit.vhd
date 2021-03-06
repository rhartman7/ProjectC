library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity mux_21_10_bit is
	generic(N : integer := 10);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end mux_21_10_bit;

architecture structure of mux_21_10_bit is 

component mux_21
	 	port(i_X  : in std_logic;
		i_Y: in std_logic;
		s_1 : in std_logic;
		o_Z : out std_logic);
end component;

begin

gmux_n: for i in 0 to N-1 generate
mux_21_i: mux_21
port MAP(
	i_X => i_X(i),
	i_Y => i_Y(i),
	s_1 => s_1,
	o_Z => o_Z(i));


end generate;
end structure;