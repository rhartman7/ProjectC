library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity hazard_detection is
  port(
    ex_mem_controller   : in std_logic_vector(12 downto 0);
    id_ex_controller   :   in std_logic_vector(12 downto 0);
    id_controller     : in std_logic_vector(12 downto 0);
    if_id_reset       : out std_logic;
    id_ex_RegRt       : in std_logic_vector(4 downto 0);
    id_ex_RegRs       : in std_logic_vector(4 downto 0);
    if_id_RegRt       : in std_logic_vector(4 downto 0);
    if_id_RegRs       : in std_logic_vector(4 downto 0);
    ex_mem_regRt       : in std_logic_vector(4 downto 0);
    ex_mem_stall             	     : out std_logic;
    s_reset            : in std_logic;
    id_ex_stall             	     : out std_logic;
    if_id_stall             	     : out std_logic;
    pc_stall             	     : out std_logic;
    take_Branch             : in std_logic;
    ex_mem_flush			         : out std_logic
--   id_ex_controller_out   : out std_logic_vector(12 downto 0)
	   );
    
end hazard_detection;

architecture behavior of hazard_detection is

signal ex_mem_fl, ex_mem_st, id_ex_st, if_id_st, pc_st, if_id_res: std_logic;
--signal id_ex_controller_ou : std_logic_vector(12 downto 0);
begin



process(ex_mem_fl, take_Branch, ex_mem_st, id_ex_st, if_id_st, pc_st, id_ex_RegRt, id_ex_RegRs, ex_mem_RegRt, if_id_RegRs, if_id_RegRt, id_ex_controller, id_controller, if_id_res)
  begin
if_id_res <= '0';
ex_mem_fl <= '0';
ex_mem_st <= '1';
id_ex_st <= '1';
if_id_st <= '1';
pc_st <= '1';
--id_ex_controller_ou <= id_ex_controller;
--stall= write enable is zero. stall a pipeline register stall the ones before it and PC. Nothing gets written to PC, IF/ID, ID/EX. Flush very nexxt pipeline registerFlush EX/MEM pipeline
--if(s_reset = '1') then 
--  if_id_res <= '1';
--end if;

--flush= resetting the register
if(id_ex_controller(10) = '1') then	 
      if(id_ex_regRt = if_id_RegRs) then
        ex_mem_fl <= '1';
        ex_mem_st <= '0';
        id_ex_st <= '0';
        if_id_st <= '0';
        pc_st <= '0';
--        id_ex_controller_ou <= "0000000000000";

      end if;
  
      if(id_ex_regRt = if_id_RegRt) then
        ex_mem_fl <= '1';
        ex_mem_st <= '0';
        id_ex_st <= '0';
        if_id_st <= '0';
        pc_st <= '0';
--        id_ex_controller_ou <= "0000000000000";

      end if;
end if;

if(id_ex_controller(2) = '1') then
 -- if_id_st <= '0';
  if_id_res <= '1';
end if;
end process;
        if_id_reset <= if_id_res;
        ex_mem_stall <= ex_mem_st;
        id_ex_stall <= id_ex_st;
        if_id_stall <= if_id_st;

        pc_stall <= pc_st;
        ex_mem_flush <= ex_mem_fl;
--        id_ex_controller_out <= id_ex_controller_ou;
end behavior;