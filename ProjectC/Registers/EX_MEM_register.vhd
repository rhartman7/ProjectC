library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity EX_MEM_register is
  generic (N : integer := 32);
  
  port(
   	EX_controller 	: in std_logic_vector(10 downto 0);
	EX_alu_controller: in std_logic_vector(12 downto 0);
	EX_alu_out 	: in std_logic_vector(31 downto 0);
	EX_reg_out_2	: in std_logic_vector(31 downto 0);
	EX_branch_logic	: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	EX_MEM_controller 	: out std_logic_vector(10 downto 0);
	EX_MEM_alu_controller	: out std_logic_vector(12 downto 0);
	EX_MEM_alu_out	 	: out std_logic_vector(31 downto 0);
	EX_MEM_reg_out_2	: out std_logic_vector(31 downto 0);
	EX_MEM_branch_logic	: out std_logic_vector(31 downto 0));
  
end EX_MEM_register;

architecture structure of EX_MEM_register is
  
component N_BitRegister
  generic (N : integer := 32);
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;

component register_12_bit 
  generic (N : integer := 12);
  
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;

component register_10_bit 
  generic (N : integer := 10);
  
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;
  
  begin
    
alu_out : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => EX_alu_out,
    o_Out => EX_MEM_alu_out);

reg_out_2_reg : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => EX_reg_out_2,
    o_Out => EX_MEM_reg_out_2);

control_reg : Register_10_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => EX_controller,
    o_Out => EX_MEM_controller);

alu_control_reg : register_12_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => EX_alu_controller,
    o_Out => EX_MEM_alu_controller);

branch_logic_reg: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => '1',
    i_Input => EX_branch_logic,
    o_Out => EX_MEM_branch_logic);



end structure;