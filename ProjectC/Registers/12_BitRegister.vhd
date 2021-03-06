library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity register_13_bit is
  generic (N : integer := 13);
  
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end register_13_bit;

architecture structure of register_13_bit is
  
  component dff
      port(
       i_CLK        : in std_logic;     -- Clock input
       i_RST        : in std_logic;     -- Reset input
       i_WE         : in std_logic;     -- Write enable input
       i_D          : in std_logic;     -- Data value input
       o_Q          : out std_logic);   -- Data value output

  end component;
  
  begin
    
    G1: for i in 0 to N-1 generate
      
      d_ff: dff
        port map(
          i_CLK       =>         i_CLK,
          i_RST       =>         i_RST,
          i_WE        =>         i_WE,
          i_D         =>         i_Input(i),
          o_Q         =>         o_Out(i));
    
  end generate;
  
end structure;