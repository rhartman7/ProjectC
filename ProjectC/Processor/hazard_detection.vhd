library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity hazard_detection is
  port(
    if_id_controller        : in std_logic_vector(12 downto 0);
    take_Branch             : in std_logic;
    stall             	     : out std_logic;
    ex_mem_flush			         : out std_logic;
	   if_id_flush		          : out std_logic
	   );
    
end hazard_detection;

architecture behavior of hazard_detection is

signal ex_mem_fl, if_id_fl, st: std_logic;

begin



process(ex_mem_fl, if_id_fl, st, if_id_controller, take_Branch)
  begin
    
ex_mem_fl <= '0';
if_id_fl <= '0';
st   <= '1';
--stall= write enable is zero. stall a pipeline register stall the ones before it and PC. Nothing gets written to PC, IF/ID, ID/EX. Flush very nexxt pipeline registerFlush EX/MEM pipeline

--flush= resetting the register
  
  if(if_id_controller(10)= '1') then
      st<= '0';
	   ex_mem_fl <='1';
  end if;
      
  if(take_Branch = '1') then
    if_id_fl <= '1';
	end if; 

end process;

stall <= st;
if_id_flush <= if_id_fl;
ex_mem_flush <= ex_mem_fl;
end behavior;