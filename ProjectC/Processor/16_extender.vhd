library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity  extender_16 is 
  	port(
		extend_in  : in std_logic_vector(15 downto 0);
		sign_sel  : in std_logic;
		extend_out  : out std_logic_vector(31 downto 0));
end extender_16;

architecture dataflow of extender_16 is
begin
process_1 : process(sign_sel, extend_in)
	begin
	if sign_sel = '0' then
  	extend_out <= x"0000" & extend_in ;
	else 
	extend_out(31 downto 16) <= (others => extend_in(15));
	extend_out(15 downto 0) <= extend_in;
	end if;
	end process;
  
end dataflow;


