library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity mux_4_1_8 is
	generic(N : integer := 8);
  	port(	i_00  : in std_logic_vector(N-1 downto 0);
		i_01  : in std_logic_vector(N-1 downto 0);
		i_10  : in std_logic_vector(N-1 downto 0);
		i_11  : in std_logic_vector(N-1 downto 0);
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic_vector(N-1 downto 0));
end mux_4_1_8;

architecture behavioral of mux_4_1_8 is 




begin
gmux_n: for i in 0 to N-1 generate
process (sel, i_00, i_01, i_10, i_11)
begin
	case sel is 
		when "00" => o_Z(i) <= i_00(i); 
		when "01" => o_Z(i) <= i_01(i);
		when "10" => o_Z(i) <= i_10(i);
		when "11" => o_Z(i) <= i_11(i);
		when others => o_Z(i) <= '0';
	end case;
end process;
end generate;
end behavioral;
