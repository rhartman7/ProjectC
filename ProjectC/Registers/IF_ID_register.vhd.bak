library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity IF_ID_register is
  generic (N : integer := 32);
  
  port(
   	IF_instruction 	: in std_logic_vector(31 downto 0);
	IF_pc		: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	IF_ID_instruction : out  std_logic_vector(31 downto 0);
   	IF_ID_pc        	: out std_logic_vector(31 downto 0));
  
end IF_ID_register;

architecture structure of IF_ID_register is
  
component N_BitRegister
  generic (N : integer := 32);
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;
  
  begin
    
instruction : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => IF_instruction,
    o_Out => IF_ID_instruction);

PC : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => IF_pc,
    o_Out => IF_ID_pc);

end structure;