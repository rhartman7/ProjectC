library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity N_Bit_FullAdderStructural is
  
  generic(N : integer := 32);
  
  port(
    a_input_n   :   in std_logic_vector(N-1 downto 0);
    b_input_n   :   in std_logic_vector(N-1 downto 0);
    i_Cin_n     :   in std_logic;
    o_Sum_n     :   out std_logic_vector(N-1 downto 0);
    o_Cout_n    :   out std_logic);
    
end N_Bit_FullAdderStructural;

architecture structure of N_Bit_FullAdderStructural is 

component FullAdderStructural is
  
  port(
    a_input   :   in std_logic;
    b_input   :   in std_logic;
    i_Cin     :   in std_logic;
    o_Sum     :   out std_logic;
    o_Cout    :   out std_logic);
    
end component;

signal      carry     : std_logic;

begin
  
  G1: for i in 0 to N-1 generate
    
    NBitFullAdder: FullAdderStructural
      port map(
        a_input     =>     a_input_n(i),
        b_input     =>     b_input_n(i),
        i_Cin       =>     i_Cin_n,
        o_Sum       =>     o_Sum_n(i),
        o_Cout      =>     o_Cout_n);
    
  end generate;
  
end structure;