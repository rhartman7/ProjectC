library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity hazard_detection is
  port(
    if_id_controller        : in std_logic_vector(31 downto 0);
    take_Branch             : in std_logic;
    stall             	 : out std_logic;
    ex_mem_flush			 : out std_logic;
	if_id_flush		 : out std_logic);
    
end hazard_detection;

architecture behavior of hazard_detection is

signal ex_mem_flush, if_id_flush, stall: std_logic;

begin

ex_mem_flush = '0';
if_id_flush = '0';
stall   = '1';

process
  begin
--stall= write enable is zero. stall a pipeline register stall the ones before it and PC. Nothing gets written to PC, IF/ID, ID/EX. Flush very nexxt pipeline registerFlush EX/MEM pipeline

--flush= resetting the register
  
  if(id_ex_controller= '1') then
        stall= '0';
	   ex_mem_flush ='1';
  end if;
      
  if(take_Branch = '1') then
    if_id_flush = '1';
	end if; 
wait for 100 ns;
end process;

load_stall_haz <= load_stall;
branch_flush_haz <= branch_flush;
end behavior;