library IEEE;
use IEEE.std_logic_1164.all;
use work.all;


entity OneBitALU is
  
  port(
    operation     :     in std_logic_vector(2 downto 0);
    a_input       :     in  std_logic;
    b_input       :     in  std_logic;
    c_in          :     in  std_logic;
    less          :     in  std_logic;
    result        :     out std_logic;
    sum           :     out std_logic;
    c_out         :     out std_logic);
    
end OneBitALU;

architecture structure of OneBitALU is
  
component Eightto1Mux is
  port(
    input        :       in  std_logic_vector(7 downto 0);
    sel3         :       in  std_logic_vector(2 downto 0);
    output       :       out std_logic);
    
end component;
  
  signal and_out, or_out, xor_out, nand_out, nor_out, FullAdder_out     :     std_logic;
  signal mux_in                                                         :     std_logic_vector(7 downto 0);
  
  begin
    
    mux: Eightto1Mux
      port map(
        input         =>        mux_in,
        sel3          =>        operation,
        output         =>        result);
    
    
    and_out                  <=         (a_input AND  b_input);
    
    or_out                   <=         (a_input OR   b_input);
    
    xor_out                  <=         (a_input XOR  b_input);
    
    nand_out                 <=         (a_input NAND b_input);
    
    nor_out                  <=         (a_input NOR  b_input);
    
    FullAdder_out            <=         (a_input XOR (b_input XOR c_in));
    
    sum                      <=         (a_input XOR (b_input XOR c_in));
    
    c_out                    <=         ((a_input AND c_in) OR (b_input AND c_in) OR (a_input AND b_input));
    
    mux_in(0)                <=         and_out;
    mux_in(1)                <=         or_out;
    mux_in(2)                <=         xor_out;
    mux_in(3)                <=         nand_out;
    mux_in(4)                <=         nor_out;
    mux_in(5)                <=         FullAdder_out;
    mux_in(6)                <=         less;
    mux_in(7)                <=         '0';
    
    
end structure;