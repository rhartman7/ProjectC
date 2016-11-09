library IEEE;
use IEEE.std_logic_1164.all;
use work.array2d.all;
use work.all;

Entity Multiplier is

  port (
    a_input       :       in  std_logic_vector(31 downto 0);
    b_input       :       in  std_logic_vector(31 downto 0);
    out_32        :       out std_logic_vector(31 downto 0));
end Multiplier;


architecture structure of Multiplier is
  
  component FullAdderStructural is
  
    port(
      a_input   :   in std_logic;
      b_input   :   in std_logic;
      i_Cin     :   in std_logic;
      o_Sum     :   out std_logic;
      o_Cout    :   out std_logic);
    
  end component;
  
  
  
  signal      and_AB     :      array32_bit;
  signal      carry      :      array32_bit;
  signal      sum        :      array32_bit;
  
  begin
    
    G1: for i in 0 to 31 generate               --create all AND gates and their outputs
      
      and_AB(0, i)      <=        (a_input(0)   and     b_input(i));
      and_AB(1, i)      <=        (a_input(1)   and     b_input(i));
      and_AB(2, i)      <=        (a_input(2)   and     b_input(i));
      and_AB(3, i)      <=        (a_input(3)   and     b_input(i));
      and_AB(4, i)      <=        (a_input(4)   and     b_input(i));
      and_AB(5, i)      <=        (a_input(5)   and     b_input(i));
      and_AB(6, i)      <=        (a_input(6)   and     b_input(i));
      and_AB(7, i)      <=        (a_input(7)   and     b_input(i));
      and_AB(8, i)      <=        (a_input(8)   and     b_input(i));
      and_AB(9, i)      <=        (a_input(9)   and     b_input(i));
      and_AB(10, i)     <=       (a_input(10)   and     b_input(i));
      and_AB(11, i)     <=       (a_input(11)   and     b_input(i));
      and_AB(12, i)     <=       (a_input(12)   and     b_input(i));
      and_AB(13, i)     <=       (a_input(13)   and     b_input(i));
      and_AB(14, i)     <=       (a_input(14)   and     b_input(i));
      and_AB(15, i)     <=       (a_input(15)   and     b_input(i));
      and_AB(16, i)     <=       (a_input(16)   and     b_input(i));
      and_AB(17, i)     <=       (a_input(17)   and     b_input(i));
      and_AB(18, i)     <=       (a_input(18)   and     b_input(i));
      and_AB(19, i)     <=       (a_input(19)   and     b_input(i));
      and_AB(20, i)     <=       (a_input(20)   and     b_input(i));
      and_AB(21, i)     <=       (a_input(21)   and     b_input(i));
      and_AB(22, i)     <=       (a_input(22)   and     b_input(i));
      and_AB(23, i)     <=       (a_input(23)   and     b_input(i));
      and_AB(24, i)     <=       (a_input(24)   and     b_input(i));
      and_AB(25, i)     <=       (a_input(25)   and     b_input(i));
      and_AB(26, i)     <=       (a_input(26)   and     b_input(i));
      and_AB(27, i)     <=       (a_input(27)   and     b_input(i));
      and_AB(28, i)     <=       (a_input(28)   and     b_input(i));
      and_AB(29, i)     <=       (a_input(29)   and     b_input(i));
      and_AB(30, i)     <=       (a_input(30)   and     b_input(i));
      and_AB(31, i)     <=       (a_input(31)   and     b_input(i));
    
    end generate G1;
    
    sum(0, 0)           <=       and_AB(0, 0); 
    out_32(0)           <=       and_AB(0, 0);      -- send output of first AND gate to zeroth element of otuput
    
    G2: for i in 0 to 31 generate                   -- generate first row of adders
    
      ROW0ADD0: if (i = 0) generate
        ADDER0: FullAdderStructural
          port map(
            a_input   =>   and_AB(0, (i + 1)),      -- and output of a0 b1
            b_input   =>   and_AB(1, i),            -- and output of a1 b0
            i_Cin     =>   '0',                     -- 0 carry in
            o_Sum     =>   out_32(1),               -- first adder of row, send sum output to first element multiplier output
            o_Cout    =>   carry(0, 0));            -- output to carry row 0 element 0
        end generate ROW0ADD0;    
        
            
      ROW0ADDn: if ((i > 0) and (i < 31)) generate
        ADDERn: FullAdderStructural
          port map(
            a_input   =>   and_AB(0, (i + 1)),      -- and output of a0 b1
            b_input   =>   and_AB(1, i),            -- and output of a1 bi
            i_Cin     =>   carry(0, (i - 1)),       -- carry in from previous adder of same row
            o_Sum     =>   sum(1, (i)),             -- output to sum row 1 element i
            o_Cout    =>   carry(0, i));            -- output to carry row 0 element i
        end generate ROW0ADDn;
            
            
      ROW0ADD31: if(i = 31) generate
        ADDER31: FullAdderStructural
          port map(
            a_input   =>   '0',                     -- a input 0 for adder31 of row 0
            b_input   =>   and_AB(1, i),            -- and output of a1 b31
            i_Cin     =>   carry(0, (i - 1)),       -- carry in from previous adder of same row
            o_Sum     =>   sum(1, (i)),             -- outout to sum row 1 element 31
            o_Cout    =>   carry(0, i));            -- output to carry row 0 element 31
        end generate ROW0ADD31;
    end generate G2;
        
    G3: for i in 2 to 31 generate                   -- generate 30 more rows of adders
      
      G4: for j in 0 to 31 generate                 -- generate 32 adders per row
      
        ROWiADD0: if (j = 0) generate
          ADDER0: FullAdderStructural
            port map(
              a_input   =>   sum((i - 1), (j + 1)),  -- sum from previous row and one elemnt forward
              b_input   =>   and_AB((i), j),         -- and output of ai b0
              i_Cin     =>   '0',                    -- 0 carry in
              o_Sum     =>   out_32(i),              --first adder of row, send sum output to multiplier output
              o_Cout    =>   carry(i, j));           -- output to carry row i element 0
          end generate ROWiADD0;
          
            
        ROWiADDn: if ((j > 0) and (j < 31)) generate
          ADDERn: FullAdderStructural
            port map(
              a_input   =>   sum((i - 1), (j + 1)),  -- sum from previos row and one element forward
              b_input   =>   and_AB((i), j),         -- and output from ai bj
              i_Cin     =>   carry(i, (j - 1)),      -- carry in from previous adder of same row
              o_Sum     =>   sum(i, j),              -- output to sum row i element j
              o_Cout    =>   carry(i, j));           -- output to carry row i element j
          end generate ROWiADDn;
              
            
        ROWiADD31: if(j = 31) generate
          ADDER31: FullAdderStructural
            port map(
              a_input   =>   carry((i - 1), j),      -- carry in from previous rows 31st adder
              b_input   =>   and_AB(i, j),           -- and ouptut from ai bj
              i_Cin     =>   carry(i, (j - 1)),      -- carry in from previous adder of same row
              o_Sum     =>   sum(i, (j)),            -- output to sum row i element 31
              o_Cout    =>   carry(i, j));           -- output to carry row i element 31
          end generate ROWiADD31;
       
       end generate G4;
    end generate G3;

end structure;
        