library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity mux_4_1 is
  	port(	i_00  : in std_logic;
		i_01  : in std_logic;
		i_10  : in std_logic;
		i_11  : in std_logic;
		sel : in std_logic_vector(1 downto 0);
		o_Z : out std_logic);
end mux_4_1;

architecture structure of mux_4_1 is 



begin

process (sel, i_00, i_01, i_10, i_11)
begin
	case SEL is 
		when "00" => o_Z <= i_00; 
		when "01" => o_Z <= i_01;
		when "10" => o_Z <= i_10;
		when "11" => o_Z <= i_11;
		when others => o_Z <= '0';
	end case;
end process;

end structure;