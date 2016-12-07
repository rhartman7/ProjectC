library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity SixteenTo32Extender is
  port(
    input16           :   in  std_logic_vector(15 downto 0);
    control           :   in  std_logic;
    output32          :   out std_logic_vector(31 downto 0));
end SixteenTo32Extender;

architecture structure of SixteenTo32Extender is

begin
  
process
  begin
    
    if control = '1' then
      if input16(15) = '1' then				
      	output32 <= x"FFFF" & input16;
      else
	     output32 <= x"0000" & input16;
      end if;
      
    else
      output32 <= x"0000" & input16;
  end if;
  wait for 100 ns;
      
end process;
end structure;
