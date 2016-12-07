library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity forwarding is
  port(
    ex_mem_RegWen       : in  std_logic;                          -- WrEn EX/MEM
    mem_wb_RegWen       : in  std_logic;                          -- WrEn MEM/WB
    id_ex_instruction   : in  std_logic_vector(31 downto 0);      -- Instruction of ID/EX
    id_ex_RegRs         : in  std_logic_vector(4 downto 0);       -- Address of rs ID/EX
    id_ex_RegRt         : in  std_logic_vector(4 downto 0);       -- Address of rt ID/EX
    ex_mem_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd EX/MEM
    mem_wb_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd MEM/WB
    ex_mem_RegRt        : in  std_logic_vector(4 downto 0);       -- Address of rt EX/MEM
    ex_mem_RegRs         : in  std_logic_vector(4 downto 0);      -- Address of rs EX/MEM
    mem_wb_RegRt        : in  std_logic_vector(4 downto 0);       -- Address pf rt MEM/WB
    is_Link             : in  std_logic;
    is_rd_rt_ex_mem     : in std_logic;
    is_rd_rt_mem_wb     : in std_logic;    
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
signal is_mult_Rtype   : std_logic;
signal isLoad      : std_logic;
signal isImmediate : std_logic;
signal forA         : std_logic_vector(2 downto 0);
signal forB         : std_logic_vector(2 downto 0);
signal ex_mem_reg   :std_logic_vector(4 downto 0);
signal mem_wb_reg   : std_logic_vector(4 downto 0);

begin



process(ex_mem_RegWen,mem_wb_RegWen,id_ex_RegRs,id_ex_RegRt,ex_mem_RegRd,mem_wb_RegRd,ex_mem_RegRt,ex_mem_RegRs,mem_wb_RegRt,is_Link, isImmediate,isLoad,is_mult_Rtype, ex_mem_reg, mem_wb_reg, memHazA, memHazB)
  begin


ex_mem_reg <= ex_mem_RegRd when (is_rd_rt_ex_mem = '0') else ex_mem_RegRt;    
mem_wb_reg <= mem_wb_RegRd when (is_rd_rt_mem_wb = '0') else mem_wb_RegRt; 

memHazA    <=     '1' when NOT((mem_wb_RegWen = '1') AND (ex_mem_RegRd /= b"00000") AND (ex_mem_reg = id_ex_RegRs)) else '0';
memHazB    <=     '1' when NOT((mem_wb_RegWen = '1') AND (ex_mem_RegRd /= b"00000") AND (ex_mem_reg = id_ex_RegRt)) else '0';
is_mult_Rtype <=  '1' when  (id_ex_instruction(31 downto 26) = b"000000") OR (id_ex_instruction(31 downto 26) = b"011100") else '0';
isLoad     <=     '1' when ((id_ex_instruction(31 downto 26) = b"100000") OR (id_ex_instruction(31 downto 26) = b"100001") OR (id_ex_instruction(31 downto 26) = b"100011") OR
                            (id_ex_instruction(31 downto 26) = b"100100") OR (id_ex_instruction(31 downto 26) = b"100101") OR (id_ex_instruction(31 downto 26) = b"101000") OR
                            (id_ex_instruction(31 downto 26) = b"101001") OR (id_ex_instruction(31 downto 26) = b"101011")) else '0';
isImmediate     <=     '1' when ((id_ex_instruction(31 downto 26) = b"001000") OR (id_ex_instruction(31 downto 26) = b"001001") OR (id_ex_instruction(31 downto 26) = b"001100") OR
                            (id_ex_instruction(31 downto 26) = b"001101") OR (id_ex_instruction(31 downto 26) = b"001110") OR (id_ex_instruction(31 downto 26) = b"001010") OR
                            (id_ex_instruction(31 downto 26) = b"001011") OR (id_ex_instruction(31 downto 26) = b"001111")) else '0';   
forA       <=     "000";
forB       <=     "000";

if(is_mult_Rtype = '1') then  
  --EX Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(ex_mem_reg = id_ex_RegRs) then
        forA <= "001";
      end if;
    end if;
  end if;
  
  --MEM Hazard A
  if(mem_wb_RegWen = '1') then
    if(mem_wb_reg /= b"00000") then
      if(memHazA = '1') then
        if(mem_wb_reg = id_ex_RegRs) then
          forA <= "010";
        end if;
      end if;
    end if;
  end if;
  
  -- EX Hazard B
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(ex_mem_reg = id_ex_RegRt) then
        forB <= "001";
      end if;
    end if;
  end if;
  
  -- MEM Hazard B
  if(mem_wb_RegWen = '1') then
    if(mem_wb_reg /= b"00000") then
      if(memHazB = '1') then
        if(mem_wb_reg = id_ex_RegRt) then
          forB <= "010";
        end if;
      end if;
    end if;
  end if;
  
end if;  

if(isLoad = '1') then

  -- Load hazard A Rt
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
        if(ex_mem_reg = id_ex_RegRs) then
          forA <= "011";
      end if;
    end if;
  end if;

  -- Load hazard B Rs
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(MemHazA = '1') then 
        if(mem_wb_reg = id_ex_RegRs) then
            forB <= "011";
          end if;
      end if;
     end if;
  end if;
end if;

if(isImmediate = '1') then 
   --Immediate Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
        if(ex_mem_reg = id_ex_RegRs) then
          forA <= "100";
      end if;
    end if;
  end if;

   --Immediate Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(MemHazA = '1') then
        if(mem_wb_reg = id_ex_RegRs) then
          forA <= "101";
        end if;
      end if;
      end if;
    end if;
end if;
  
  -- Link Hazard A
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(is_Link = '1') then
        if(id_ex_RegRs = b"11111") then
          forA <= "110";
        end if;
      end if;
    end if;
  end if;
  
    -- Link Hazard B
  if(ex_mem_RegWen = '1') then
    if(ex_mem_reg /= b"00000") then
      if(is_Link = '1') then
        if(id_ex_RegRt = b"11111") then
          forB <= "110";
        end if;
      end if;
    end if;
  end if;

--wait for 100 ns;
end process;

forwardA <= forA;
forwardB <= forB;
end behavior;