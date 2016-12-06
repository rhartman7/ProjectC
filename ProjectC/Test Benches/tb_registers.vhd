library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_registers is
end tb_registers;

architecture behavior of tb_registers is

-- Declare the component we are going to instantiate

--registers
component IF_ID_register
  generic (N : integer := 32);
  
  port(
   	IF_instruction 	: in std_logic_vector(31 downto 0);
	IF_pc		: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	wr_en   : in std_logic;
	clk		: in std_logic;
    	IF_ID_instruction : out  std_logic_vector(31 downto 0);
   	IF_ID_pc        	: out std_logic_vector(31 downto 0));
  
end component;

component ID_EX_register
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
	ID_EX_we    : in std_logic;
 	ID_EX_controller 	: out std_logic_vector(12 downto 0);
	ID_EX_alu_controller	: out std_logic_vector(10 downto 0);
	ID_EX_reg_out_1 	: out std_logic_vector(31 downto 0);
	ID_EX_reg_out_2		: out std_logic_vector(31 downto 0);
	ID_EX_immediate		: out std_logic_vector(31 downto 0);
	ID_EX_instruction	: out std_logic_vector(31 downto 0);
	ID_EX_branch_logic	: out std_logic_vector(31 downto 0));
  
end component;


component EX_MEM_register
  generic (N : integer := 32);
  
  port(
    EX_instruction : in std_logic_vector(31 downto 0);
   	EX_controller 	: in std_logic_vector(12 downto 0);
	EX_alu_controller: in std_logic_vector(10 downto 0);
	EX_alu_out 	: in std_logic_vector(31 downto 0);
	EX_reg_out_2	: in std_logic_vector(31 downto 0);
	EX_branch_logic	: in std_logic_vector(31 downto 0);
	EX_reg_write	: in std_logic_vector(4 downto 0);
	EX_reg_out_1 : std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
	EX_MEM_we : in std_logic;
	EX_MEM_instruction : out std_logic_vector(31 downto 0);
    	EX_MEM_controller 	: out std_logic_vector(12 downto 0);
	EX_MEM_alu_controller	: out std_logic_vector(10 downto 0);
	EX_MEM_alu_out	 	: out std_logic_vector(31 downto 0);
	EX_MEM_reg_out_2	: out std_logic_vector(31 downto 0);
	EX_MEM_reg_out_1 : out std_logic_vector(31 downto 0);
	EX_MEM_branch_logic	: out std_logic_vector(31 downto 0);
	EX_MEM_reg_write	: out std_logic_vector(4 downto 0));
end component;

component MEM_WB_register 
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
end component;

-- Signals to connect to the struct_ones module
signal ID_reg_out_1, ID_reg_out_2, ID_EX_reg_out_1, ID_EX_reg_out_2, EX_MEM_reg_out_2, EX_MEM_reg_out_1, MEM_WB_reg_out_2: std_logic_vector(31 downto 0);
--Signals for Data Memory
signal  MEM_data_mem_out, MEM_WB_data_mem_out: std_logic_vector(31 downto 0);
--Signals for PC and Instruction Memory
signal IF_instruction, IF_ID_instruction, ID_EX_instruction, EX_MEM_instruction, MEM_WB_instruction: std_logic_vector(31 downto 0);
--register write
signal EX_MEM_reg_write, MEM_WB_reg_write : std_logic_vector(4 downto 0);
-- Signal for Immediate
signal ID_immediate,ID_EX_immediate : std_logic_vector(31 downto 0);
--signals for ALU
signal EX_alu_out, EX_MEM_alu_out, MEM_WB_alu_out : std_logic_vector(31 downto 0);

--signals for PC
signal  IF_ID_PC, IF_PC      : std_logic_vector(31 downto 0); 
--brnach
signal ID_branch_logic, ID_EX_branch_logic, EX_MEM_branch_logic, MEM_WB_branch_logic  : std_logic_vector(31 downto 0);
--hazard detection
signal stall,ex_mem_flush,if_id_flush : std_logic;

--CONTROL SIGNALS ALU
signal  ID_controller,ID_EX_controller, EX_MEM_controller, MEM_WB_controller : std_logic_vector(12 downto 0);

--CONTROL SIGNALS 
signal ID_alu_controller, ID_EX_alu_controller, EX_MEM_alu_controller, MEM_WB_alu_controller : std_logic_vector(10 downto 0);

signal s_reset,clk, ID_EX_we, EX_MEM_we, MEM_WB_we : std_logic;
signal s_write_address_final : std_logic_vector(4 downto 0);


begin

if_id_reg: IF_ID_register
  port MAP(   
   	IF_instruction=>IF_instruction,
	IF_pc=>IF_PC,
	reset=>s_reset,--if_id_flush,
	wr_en =>stall,                   ---!!!!!!!
	clk=>clk,
 	IF_ID_instruction=> IF_ID_instruction,
 	IF_ID_pc=>IF_ID_PC);

ID_EX_reg: ID_EX_register 
  port MAP(
 	ID_controller=>ID_controller,
	ID_alu_controller=>ID_alu_controller,
	ID_reg_out_1=>ID_reg_out_1,
	ID_reg_out_2=>ID_reg_out_2,
	ID_immediate=>ID_immediate,
	ID_instruction=>IF_ID_instruction,
	ID_branch_logic=> ID_branch_logic,
	reset=>s_reset,
	clk=>clk,
	ID_EX_we => ID_EX_we,
    	ID_EX_controller=>ID_EX_controller,
	ID_EX_alu_controller=>ID_EX_alu_controller,
	ID_EX_reg_out_1=>ID_EX_reg_out_1,
	ID_EX_reg_out_2=>ID_EX_reg_out_2,
	ID_EX_immediate=>ID_EX_immediate,
	ID_EX_instruction=>ID_EX_instruction,
	ID_EX_branch_logic=>ID_EX_branch_logic);

Ex_MEM_Reg: EX_MEM_register
port MAP	(
  EX_instruction => ID_EX_instruction,
   	EX_controller 		=>ID_EX_controller,
	EX_alu_controller	=>ID_EX_alu_controller,
	EX_alu_out 		=>EX_alu_out,
	EX_reg_out_2		=>ID_EX_reg_out_2,
	EX_branch_logic		=>ID_EX_branch_logic,
	EX_reg_write		=>s_write_address_final,
	EX_reg_out_1 => ID_EX_reg_out_1,
	reset 			=>ex_mem_flush,       --!!!!!!!!!!!!!!!!!!!!
	clk			=>clk,
	EX_MEM_we	=> EX_MEM_we,
	EX_MEM_instruction => EX_MEM_instruction,
    	EX_MEM_controller 	=>EX_MEM_controller,
	EX_MEM_alu_controller	=>EX_MEM_alu_controller,
	EX_MEM_alu_out	 	=>EX_MEM_alu_out,
	EX_MEM_reg_out_2	=>EX_MEM_reg_out_2,
	EX_MEM_reg_out_1 => EX_MEM_reg_out_1,
	EX_MEM_branch_logic	=>EX_MEM_branch_logic,
	EX_MEM_reg_write	=>EX_MEM_reg_write);

MEM_WB_reg: MEM_WB_register

  port MAP(
    MEM_instruction => EX_MEM_instruction,
   	MEM_controller 		=>EX_MEM_controller,
	MEM_alu_controller	=>EX_MEM_alu_controller,
	MEM_alu_out 		=>EX_MEM_alu_out,
	MEM_data_mem_out	=>MEM_data_mem_out,
	MEM_branch_logic	=>EX_MEM_branch_logic, 
	MEM_reg_write		=>EX_MEM_reg_write,
	MEM_reg_out_2 => EX_MEM_reg_out_2,
	reset 		=>s_reset,
	clk		=>clk,
	MEM_WB_we		=> MEM_WB_we,
	MEM_WB_instruction => MEM_WB_instruction,
	MEM_WB_reg_out_2 => MEM_WB_reg_out_2,
    	MEM_WB_controller 	=>MEM_WB_controller ,
	MEM_WB_alu_controller	=>MEM_WB_alu_controller ,
	MEM_WB_alu_out	 	=>MEM_WB_alu_out,
	MEM_WB_data_mem_out	=>MEM_WB_data_mem_out,
	MEM_WB_branch_logic	=>MEM_WB_branch_logic,
	MEM_WB_reg_write	=>MEM_WB_reg_write);


 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin


IF_instruction <= x"FFFF0000";
s_reset <= '0';
IF_pc<=x"00000004";
stall <= '1';
ID_EX_we <= '1';
EX_MEM_we <= '1';
MEM_WB_we <= '1';
clk <=  clk;
ID_controller <= "0000000000000";
ID_alu_controller <= "00000000000";
ID_reg_out_1 <= x"00001111";
ID_reg_out_2 <=x"00001111";
ID_immediate <= x"FFFFFFFF";
ID_branch_logic <= x"0000FFFF";
EX_alu_out <= x"0000FFFF";
MEM_data_mem_out <= x"FFFF0000";
s_write_address_final <= "00000";



	wait;
  end process;
end behavior;