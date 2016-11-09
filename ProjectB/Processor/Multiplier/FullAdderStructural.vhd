library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity FullAdderStructural is
  
  port(
    a_input   :   in std_logic;
    b_input   :   in std_logic;
    i_Cin     :   in std_logic;
    o_Sum     :   out std_logic;
    o_Cout    :   out std_logic);
    
end FullAdderStructural;

architecture structure of FullAdderStructural is 

component xor2

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component and2

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

component or2 is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end component;

signal a_xor_b, a_and_b, cin_and_xor      :        std_logic;

begin
  
  xor1: xor2
    port map(
      i_A     =>      a_input,
      i_B     =>      b_input,
      o_F     =>      a_xor_b);
      
  and1: and2
    port map(
      i_A     =>      a_input,
      i_B     =>      b_input,
      o_F     =>      a_and_b);
      
  xor3: xor2
    port map(
      i_A     =>      a_xor_b,
      i_B     =>      i_Cin,
      o_F     =>      o_Sum);
      
  and3: and2
    port map(
      i_A     =>      a_xor_b,
      i_B     =>      i_Cin,
      o_F     =>      cin_and_xor);
      
  or1: or2
    port map(
      i_A     =>      cin_and_xor,
      i_B     =>      a_and_b,
      o_F     =>      o_Cout);
      
end structure;