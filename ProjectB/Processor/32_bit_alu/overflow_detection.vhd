library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity overflow_detection is
  	port(
		a_in  : in std_logic;
		b_in 	: in std_logic;
		sum_in 	: in std_logic;
		load_type : in std_logic;
		c_in	: in std_logic;
		overflow_out : out std_logic);
end overflow_detection;

architecture structure of overflow_detection is 
begin
	process(load_type, a_in, b_in, sum_in, c_in)
	
	begin
		if (load_type = '1') then 
			overflow_out <= c_in;
		else 
			overflow_out <= (a_in and b_in and (not sum_in)) or ((not a_in) and (not b_in) and sum_in);
		end if;
	end process;

end structure;