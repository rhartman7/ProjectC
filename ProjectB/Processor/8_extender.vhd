library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity  extender_8 is 
  	port(
		extend_in  : in std_logic_vector(7 downto 0);
		sign_sel  : in std_logic;
		extend_out  : out std_logic_vector(31 downto 0));
end extender_8;

architecture dataflow of extender_8 is
begin
process_1 : process(sign_sel, extend_in)
	begin
	if sign_sel = '0' then
  	extend_out <= x"000000" & extend_in ;
	else 
	extend_out <= x"111111" & extend_in;
	end if;
	end process;
  
end dataflow;

