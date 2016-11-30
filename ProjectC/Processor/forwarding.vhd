library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity forwarding is
  port(
    ex_mem_RegWen       : in  std_logic;                          -- WrEn EX/MEM
    mem_wb_RegWen       : in  std_logic;                          -- WrEn MEM/WB
    id_ex_RegRs         : in  std_logic_vector(4 downto 0);       -- Address of rs ID/EX
    id_ex_RegRt         : in  std_logic_vector(4 downto 0);       -- Address of rt ID/EX
    ex_mem_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd EX/MEM
    mem_wb_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd MEM/WB
    ex_mem_RegRt        : in  std_logic_vector(4 downto 0);       -- Address of rt EX/MEM
    ex_mem_RegRs         : in  std_logic_vector(4 downto 0);       -- Address of rs EX/MEM
    mem_wb_RegRt        : in  std_logic_vector(4 downto 0);       -- Address pf rt MEM/WB
    is_Link             : in  std_logic;

    
    forwardA            : out std_logic_vector(2 downto 0);       -- when 000, first ALU operand from reg file
                                                                  -- when 001, first ALU operand forwarded from prior ALU result
                                                                  -- when 010, first ALU operand forwarded from DMEM or earlier ALU result
                                                                  -- when 011, Load hazard
                                                                  -- when 100, I-type instruction
                                                                  -- when 101, I-type 2 instructions later
    
    forwardB            : out std_logic_vector(2 downto 0));      -- when 000, second ALU operand from reg file
                                                                  -- when 001, second ALU operand forwarded from prior ALU result
                                                                  -- when 010, second ALU operand forwarded from DMEM or earlier ALU result
                                                                  -- when 011, Load hazard
                                                                  -- when 100, I-type instruction
                                                                  -- when 101, I-type 2 instructions later
end forwarding;

architecture behavior of forwarding is

signal memHazA      : std_logic;
signal memHazB      : std_logic;
signal forA         : std_logic_vector(2 downto 0);
signal forB         : std_logic_vector(2 downto 0);

begin

memHazA    <=     '1' when (NOT (mem_wb_RegWen = '1') AND (ex_mem_RegRd /= b"00000") AND (ex_mem_RegRd /= id_ex_RegRs)) else '0';
memHazB    <=     '1' when (NOT (mem_wb_RegWen = '1') AND (ex_mem_RegRd /= b"00000") AND (ex_mem_RegRd /= id_ex_RegRt)) else '0';
forA       <=     "000";
forB       <=     "000";

process
  begin
  
  --EX Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(ex_mem_RegRd = id_ex_RegRs) then
        forA <= "001";
      end if;
    end if;
  end if;
  
  --MEM Hazard A
  if(mem_wb_RegWen = '1') then
    if(mem_wb_RegRd /= b"00000") then
      if(memHazA = '1') then
        if(mem_wb_RegRd = id_ex_RegRs) then
          forA <= "010";
        end if;
      end if;
    end if;
  end if;
  
  -- EX Hazard B
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(ex_mem_RegRd = id_ex_RegRt) then
        forB <= "001";
      end if;
    end if;
  end if;
  
  -- MEM Hazard B
  if(mem_wb_RegWen = '1') then
    if(mem_wb_RegRd /= b"00000") then
      if(memHazA = '1') then
        if(mem_wb_RegRd = id_ex_RegRt) then
          forB <= "010";
        end if;
      end if;
    end if;
  end if;
  
  -- Load hazard B Rs
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(id_ex_RegRt = ex_mem_RegRs) then
          forB <= "011";
      end if;
     end if;
  end if;
  
  -- Load hazard A Rt
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(id_ex_RegRt = ex_mem_RegRt) then
          forA <= "011";
      end if;
    end if;
  end if;
 
   --Immediate Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(ex_mem_RegRt = id_ex_RegRs) then
        forA <= "100";
      end if;
    end if;
  end if;

   --Immediate Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(MemHazA = '1') then
        if(ex_mem_RegRt = id_ex_RegRs) then
        forA <= "101";
      end if;
      end if;
    end if;
  end if;
 
  -- Immeidate Hazard B
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(ex_mem_RegRt = id_ex_RegRt) then
        forB <= "100";
      end if;
    end if;
  end if;
  
  -- Immediate Hazard B
  if(mem_wb_RegWen = '1') then
    if(mem_wb_RegRd /= b"00000") then
      if(memHazA = '1') then
        if(mem_wb_RegRt = id_ex_RegRt) then
          forB <= "101";
        end if;
      end if;
    end if;
  end if;
  
  -- Link Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(is_Link = '1') then
        if(id_ex_RegRs = b"11111") then
          forA <= "110";
        end if;
      end if;
    end if;
  end if;
  
    -- Link Hazard B
  if(ex_mem_RegWen = '1') then
    if(ex_mem_RegRd /= b"00000") then
      if(is_Link = '1') then
        if(id_ex_RegRt = b"11111") then
          forB <= "110";
        end if;
      end if;
    end if;
  end if;

wait for 100 ns;
end process;

forwardA <= forA;
forwardB <= forB;
end behavior;