library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity PC_Register is
  
  port(
    PC_next           :         in  std_logic_vector(31 downto 0);
    PC_clk            :         in  std_logic;
    PC_reset          :         in  std_logic;
    PC_current        :         out std_logic_vector(31 downto 0));

end PC_Register;


architecture structure of PC_Register is
  
  component N_BitRegister is
    generic (N : integer := 32);
  
    port(
      i_CLK        : in  std_logic;
      i_RST        : in  std_logic;
      i_WE         : in  std_logic;
      i_Input      : in  std_logic_vector(N-1 downto 0);
      o_Out        : out std_logic_vector(N-1 downto 0));
  
  end component;
  
begin
  
  Store_register: N_BitRegister
    port map(
      i_CLK       =>        PC_clk,
      i_RST       =>        PC_Reset,
      i_WE        =>        '1',
      i_Input     =>        PC_next,
      o_Out       =>        PC_current);
      
end structure;