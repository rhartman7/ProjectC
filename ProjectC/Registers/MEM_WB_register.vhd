library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity MEM_WB_register is
  generic (N : integer := 32);
  
  port(
    MEM_instruction : in std_logic_vector(31 downto 0);
   	MEM_controller 		: in std_logic_vector(12 downto 0);
	MEM_alu_controller	: in std_logic_vector(10 downto 0);
	MEM_alu_out 		: in std_logic_vector(31 downto 0);
	MEM_data_mem_out	: in std_logic_vector(31 downto 0);
	MEM_branch_logic	: in std_logic_vector(31 downto 0);
	MEM_reg_write		: in std_logic_vector(4 downto 0);
	MEM_reg_out_2 : in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
	MEM_WB_we		: in std_logic;
	MEM_WB_instruction : out std_logic_vector(31 downto 0);
	MEM_WB_reg_out_2 : out std_logic_vector(31 downto 0);
    	MEM_WB_controller 	: out std_logic_vector(12 downto 0);
	MEM_WB_alu_controller	: out std_logic_vector(10 downto 0);
	MEM_WB_alu_out	 	: out std_logic_vector(31 downto 0);
	MEM_WB_data_mem_out	: out std_logic_vector(31 downto 0);
	MEM_WB_branch_logic	: out std_logic_vector(31 downto 0);
	MEM_WB_reg_write	: out std_logic_vector(4 downto 0));
  
end MEM_WB_register;

architecture structure of MEM_WB_register is
  
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

component register_5_bit
  generic (N : integer := 5);
  
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
    i_WE => MEM_WB_we,
    i_Input => MEM_alu_out,
    o_Out => MEM_WB_alu_out);

data_mem_out_reg : N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_data_mem_out,
    o_Out => MEM_WB_data_mem_out);
    
    reg_out_2: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_reg_out_2,
    o_Out => MEM_WB_reg_out_2);

control_reg : Register_13_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_controller,
    o_Out => MEM_WB_controller);

alu_control_reg : register_11_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_alu_controller,
    o_Out => MEM_WB_alu_controller);

branch_logic_reg: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_branch_logic,
    o_Out => MEM_WB_branch_logic);

instruction: N_BitRegister
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_instruction,
    o_Out => MEM_WB_instruction);

reg_write_ex_mem: register_5_bit
  port MAP(
    i_CLK  => clk,
    i_RST => reset,
    i_WE => MEM_WB_we,
    i_Input => MEM_reg_write,
    o_Out => MEM_WB_reg_write);
end structure;
