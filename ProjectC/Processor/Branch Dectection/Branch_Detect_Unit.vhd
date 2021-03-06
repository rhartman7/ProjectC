library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity branch_detection_Unit is
  port(
    instruction         :   in      std_logic_vector(31 downto 0);
    reg1                :   in      std_logic_vector(31 downto 0);
    reg2                :   in      std_logic_vector(31 downto 0);
    take_Branch         :   out     std_logic);

end branch_detection_Unit;

architecture behavior of branch_detection_Unit is
  
  signal   opCode             :    std_logic_vector(5 downto 0);
  signal   branch_link_code   :    std_logic_vector(4 downto 0);
  signal   jump_reg_code      :    std_logic_vector(5 downto 0);
  signal   isBranch           :    std_logic;
  signal   isEqual            :    std_logic;
  signal   isLessZero         :    std_logic;
  signal   isGreaterZero      :    std_logic;
  signal   isGorEqZero        :    std_logic;
  signal   isLorEqZero        :    std_logic;
  constant BEQ_instr          :    std_logic_vector(5 downto 0)         := "000100";
  constant BNE_instr          :    std_logic_vector(5 downto 0)         := "000101";
  constant BLTZ_instr         :    std_logic_vector(5 downto 0)         := "000001";
  constant BGEZ_instr         :    std_logic_vector(5 downto 0)         := "000001";
  constant BLTZAL_instr       :    std_logic_vector(5 downto 0)         := "000001";
  constant BGEZAL_instr       :    std_logic_vector(5 downto 0)         := "000001";
  constant BLEZ_instr         :    std_logic_vector(5 downto 0)         := "000110";
  constant BGTZ_instr         :    std_logic_vector(5 downto 0)         := "000111";
  constant J_instr            :    std_logic_vector(5 downto 0)         := "000010";
  constant JAL_instr          :    std_logic_vector(5 downto 0)         := "000011";
  constant JR_instr           :    std_logic_vector(5 downto 0)         := "000000";
  constant JALR_instr         :    std_logic_vector(5 downto 0)         := "000000";


begin
  
  opCode            <=        instruction(31 downto 26);
  branch_link_code  <=        instruction(20 downto 16);
  jump_reg_code     <=        instruction(5 downto 0);
  
  isEqual           <=        '1' when reg1 = reg2 else '0';
  isLessZero        <=        '1' when reg1 < x"00000000" else '0';
  isGreaterZero     <=        '1' when reg1 > x"00000000" else '0';
  isLorEqZero       <=        '1' when ((reg1 < x"00000000") OR (reg1 <= x"00000000")) else '0';
  isGorEqZero       <=        '1' when ((reg1 > x"00000000") OR (reg1 >= x"00000000")) else '0';


process(opCode, branch_link_code, jump_Reg_code, isBranch, isEqual, isLessZero, isGreaterZero, isGorEqZero, isLorEqZero)

  begin
    
  isBranch <= '0';
  
  case opCode is
    
    when BEQ_instr =>
      if(isEqual = '1') then
        isBranch        <=        '1';
      else
        isBranch        <=        '0';
      end if;
    
    when BNE_instr =>
      if(isEqual = '0') then
        isBranch        <=        '1';
      else
        isBranch        <=        '0';
      end if;  
    
    when "000001" =>
      
      if (branch_link_code = "00000") then
        
        if(isLessZero = '1') then
          isBranch        <=        '1';
        else
          isBranch        <=        '0';
        end if;
      
      elsif (branch_link_code = "00001") then
        
        if(isGorEqZero = '1') then
          isBranch        <=        '1';
        else
          isBranch        <=        '0';
        end if;
      
      elsif (branch_link_code = "10000") then
        
        if(isLessZero = '1') then
          isBranch        <=        '1';
        else
          isBranch        <=        '0';
        end if;
      
      elsif (branch_link_code = "10001") then
        
        if(isGorEqZero = '1') then
          isBranch        <=        '1';
        else
          isBranch        <=        '0';
      
        end if;
      
      else
       
       isBranch           <=    '0';
      
      end if;
      
    when BLEZ_instr =>
      if(isLorEqZero = '1') then
        isBranch        <=        '1';
      else
        isBranch        <=        '0';
      end if;

    when BGTZ_instr =>    
      if(isGreaterZero = '1') then
        isBranch        <=        '1';
      else
        isBranch        <=        '0';
      end if;
      
    when J_instr =>

      isBranch        <=        '1';
      
    when JAL_instr =>
      
      isBranch        <=        '1';
      
    when "000000" =>
      
      if(jump_reg_code = "001001") then
        isBranch        <=        '1';
      elsif(jump_reg_code = "001000") then
        isBranch        <=        '1';
    else
      isBranch <= '0';
      end if;
    
--    when JALR_instr =>
      
--      isBranch        <=        '1';

--    when BGEZ_instr =>
--      
--      if(isGorEqZero = '1') then
--        isBranch        <=        '1';
--     else
--        isBranch        <=        '0';
--      end if;

--    when BLTZAL_instr =>
--      if(isLessZero = '1') then
--        isBranch        <=        '1';
--      else
--        isBranch        <=        '0';
--      end if;
    
--    when BGEZAL_instr =>
--      if(isGorEqZero = '1') then
--        isBranch        <=        '1';
--      else
--        isBranch        <=        '0';
--     end if;
      
    when others =>
      isBranch            <=        '0';
      
end case;

end process;

take_Branch           <=        isBranch;

end behavior;