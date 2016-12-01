library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity hazard_detection is
  port(
    id_ex_instruction       : in std_logic_vector(31 downto 0);
    if_id_instruction       : in std_logic_vector(31 downto 0);
    id_ex_controller        : in std_logic_vector(31 downto 0);
    take_Branch             : in std_logic;
    PC_Write                : out std_logic;
    if_id_write             : out std_logic;
    id_ex_flush             : out std_logic;
    if_id_reset             : out std_logic);
    
end hazard_detection;

architecture behavior of hazard_detection is

signal PC_wren, if_id_wren, id_ex_fl : std_logic;

begin

PC_wren    = '1';
if_id_wren = '1';
id_ex_fl   = '1';

process
  begin
  
  if(id_ex_MemRead = '1') then
    if(id_ex_RegRt = if_id_RegRs) then
      if(id_ex_RegRt = if_id_RegRt) then
        load_stall = '1';
      end if;
    end if;
  end if;
  
  if(take_Branch = '1') then
    
 
wait for 100 ns;
end process;

load_stall_haz <= load_stall;
branch_flush_haz <= branch_flush;
end behavior;