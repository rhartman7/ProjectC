library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity ID_EX_register is
  generic (N : integer := 32);
  
  port(
 	ID_controller 	: in std_logic_vector(12 downto 0);
	ID_alu_controller: in std_logic_vector(10 downto 0);
	ID_reg_out_1 	: in std_logic_vector(31 downto 0);
	ID_reg_out_2	: in std_logic_vector(31 downto 0);
	ID_immediate	: in std_logic_vector(31 downto 0);
	ID_instruction	: in std_logic_vector(31 downto 0);
	ID_branch_logic	: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
	ID_EX_we : in std_logic;
 	ID_EX_controller 	: out std_logic_vector(12 downto 0);
	ID_EX_alu_controller	: out std_logic_vector(10 downto 0);
	ID_EX_reg_out_1 	: out std_logic_vector(31 downto 0);
	ID_EX_reg_out_2		: out std_logic_vector(31 downto 0);
	ID_EX_immediate		: out std_logic_vector(31 downto 0);
	ID_EX_instruction	: out std_logic_vector(31 downto 0);
	ID_EX_branch_logic	: out std_logic_vector(31 downto 0));
  
  
end ID_EX_register;

architecture structure of ID_EX_register is
  
component N_BitRegister
  generic (N : integer := 32);
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;

component register_13_bit
  generic (N : integer := 13);
  
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;

component register_11_bit 
  generic (N : integer := 11);
  
  port(
    i_CLK        : in  std_logic;
    i_RST        : in  std_logic;
    i_WE         : in  std_logic;
    i_Input      : in  std_logic_vector(N-1 downto 0);
    o_Out        : out std_logic_vector(N-1 downto 0));
  
end component;
  
  begin
    
reg_out_1_reg : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_reg_out_1,
    o_Out => ID_EX_reg_out_1);

reg_out_2_reg : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_reg_out_2,
    o_Out => ID_EX_reg_out_2);

control_reg : register_13_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_controller,
    o_Out => ID_EX_controller);

alu_control_reg : register_11_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_alu_controller,
    o_Out => ID_EX_alu_controller);

instruction_reg: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_instruction,
    o_Out => ID_EX_instruction);

immediate_reg : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we ,
    i_Input => ID_immediate,
    o_Out => ID_EX_immediate);

branch_logic_reg: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => ID_EX_we,
    i_Input => ID_branch_logic,
    o_Out => ID_EX_branch_logic);

end structure;