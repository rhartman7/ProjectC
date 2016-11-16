
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.all;

entity MIPS_Processor_Project_C is
  	generic(N : integer := 32);
	port(clk : in std_logic;
		s_reset : in std_logic);
end MIPS_Processor_Project_C;

architecture structure of MIPS_Processor_Project_C is 
--General components
component register_file
	port(	i_reg1 : in std_logic_vector(4 downto 0); -- address of rs
		i_reg2 : in std_logic_vector(4 downto 0); -- address of rt
		i_writereg : in std_logic_vector(4 downto 0); -- address to write to
		i_data : in std_logic_vector(31 downto 0); -- data to write at i_writereg address
		i_WE : in std_logic; -- write enable
		i_CLK : in std_logic;
		i_RST : in std_logic; -- resets entire register file
		o_reg1 : out std_logic_vector(31 downto 0); -- output data of rs address
		o_reg2 : out std_logic_vector(31 downto 0)); -- output data of rt address
end component;

component alu_mult_shift
  	port(
		a_in  : in std_logic_vector(31 downto 0);
		b_in 	: in std_logic_vector(31 downto 0);
		op 	: in std_logic_vector(2 downto 0);
		add_sub : in std_logic;
		load_type : in std_logic;
		sel_shift_v: in std_logic;
		shift_amount : in std_logic_vector(4 downto 0);
		sel_srl_sll : in std_logic;
		sel_srl_sra : in std_logic;
		load_alu_shift_mult : in std_logic_vector(1 downto 0);
		result_out : out std_logic_vector(31 downto 0);
		overflow : out std_logic;
		zero_out : out std_logic;
		c_out 	: out std_logic);
end component;

component mem 
	generic(depth_exp_of_2 	: integer := 10;
		mif_filename 	: string := "mem.mif");
	port   ( 	address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
			byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
			clock			: IN STD_LOGIC := '1';
			data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
			wren			: IN STD_LOGIC := '0';
			q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));         
end component;

component instruction_mem
	generic(depth_exp_of_2 	: integer := 10;
			mif_filename 	: string := "instruction.mif");
	port   ( 	address			: IN STD_LOGIC_VECTOR (depth_exp_of_2-1 DOWNTO 0) := (OTHERS => '0');
			byteena			: IN STD_LOGIC_VECTOR (3 DOWNTO 0) := (OTHERS => '1');
			clock			: IN STD_LOGIC := '1';
			data			: IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
			wren			: IN STD_LOGIC := '0';
			q			: OUT STD_LOGIC_VECTOR (31 DOWNTO 0));         
end component;

component mux_21_5_bit
	generic(N : integer := 5);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component store 
	port(
		alu_in : in std_logic_vector(31 downto 0);
		reg_out_2_in : in std_logic_vector(31 downto 0);
		load_size : in std_logic_vector(1 downto 0);
		store_data: out std_logic_vector(31 downto 0);
		store_byteena: out std_logic_vector(3 downto 0));
end component;

component load
	port(	
		in_memory  : in std_logic_vector(31 downto 0);
		load_which_load : in std_logic_vector(1 downto 0);
		load_type_sign : in std_logic;
		load_alu_out : in std_logic_vector(1 downto 0);
		out_load: out std_logic_vector(31 downto 0));
end component;

component mux_21_n
	generic(N : integer := 32);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component immediate
	port(	
		in_immediate  : in std_logic_vector(15 downto 0);
		in_upper_byte : in std_logic_vector(15 downto 0);
		load_which_immediate : in std_logic;
		out_immediate: out std_logic_vector(31 downto 0));
end component;

--ALU controller 
component alu_controller
	port(	
		in_op_code  : in std_logic_vector(5 downto 0);
		in_function_code : in std_logic_vector(5 downto 0);
		in_sft_amount : in std_logic_vector(4 downto 0);
		ALU_SRC: out std_logic;
		op: out std_logic_vector(2 downto 0);
		add_sub: out std_logic;
		load_type: out std_logic;
		sel_shift_v: out std_logic;
		sel_srl_sll: out std_logic;
		sel_srl_sra: out std_logic;
		load_alu_shift_mult: out std_logic_vector(1 downto 0));
end component;
--controller
component controller
	port(	
		in_op_code  : in std_logic_vector(5 downto 0);
		in_function_code : in std_logic_vector(5 downto 0);
		in_branch_code : in std_logic_vector(4 downto 0);
		reg_write: out std_logic;
		load_rd_rt: out std_logic;
		mem_to_reg: out std_logic;
		load_which_immediate: out std_logic;
		mem_write: out std_logic;
		load_size: out std_logic_vector(1 downto 0);
		load_which_load: out std_logic_vector(1 downto 0);
		load_is_jump: out std_logic;
		load_type_sign: out std_logic;
		load_is_jump_reg: out std_logic;
		load_is_And_Link: out std_logic);
end component;

--PC and Branches
  generic (N : integer := 32);
  
  port(
   	ID_controller 	: in std_logic_vector(10 downto 0);
	ID_alu_controller: in std_logic_vector(12 downto 0);
	ID_reg_out_1 	: in std_logic_vector(31 downto 0);
	ID_reg_out_2	: in std_logic_vector(31 downto 0);
	ID_immediate	: in std_logic_vector(31 downto 0);
	ID_branch_logic	: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	ID_EX_controller 	: out std_logic_vector(10 downto 0);
	ID_EX_alu_controller	: out std_logic_vector(12 downto 0);
	ID_EX_reg_out_1 	: out std_logic_vector(31 downto 0);
	ID_EX_reg_out_2		: out std_logic_vector(31 downto 0);
	ID_EX_immediate		: out std_logic_vector(31 downto 0);
	ID_EX_branch_logic	: out std_logic_vector(31 downto 0));
  
end component;



component PC_Register
  port(
    PC_next           :         in  std_logic_vector(31 downto 0);
    PC_clk            :         in  std_logic;
    PC_reset          :         in  std_logic;
    PC_current        :         out std_logic_vector(31 downto 0));
end component;


component branch_detection_Unit
  port(
    instruction         :   in      std_logic_vector(31 downto 0);
    reg1                :   in      std_logic_vector(31 downto 0);
    reg2                :   in      std_logic_vector(31 downto 0);
    take_Branch         :   out     std_logic);
end component;

component branch_logic
  port(
    PC_val            :       in  std_logic_vector(31 downto 0);         -- PC + 4 value
    isJump            :       in  std_logic;                             -- jump instruction when 1, branch otherwise
    branch_target     :       in  std_logic_vector(15 downto 0);         -- Lower 16 bits of instruction
    jump_target       :       in  std_logic_vector(25 downto 0);         -- Lower 26 bits of instruction
    isJump_reg        :       in  std_logic;                             -- 1 when jr or jalr instruction ie opcode(instr(31:26)) of 0, func (instr(5:0)) of 001000 or 100010 respectively
    jump_reg          :       in  std_logic_vector(31 downto 0);         -- New PC value if jr or jalr instruction, read from reg file location specified by instr(25:21)
    PC_new            :       out std_logic_vector(31 downto 0);         -- New PC value
    link_address      :       out std_logic_vector(31 downto 0));        -- Old PC value for linking instructions
end component;

component pc_plus_4
  port(
    a_input           :       in  std_logic_vector(31 downto 0); 
	s_reset :	in std_logic;                                           
    o_output    :      out  std_logic_vector(31 downto 0));       
end component;

--registers
component IF_ID_register
  generic (N : integer := 32);
  
  port(
   	IF_instruction 	: in std_logic_vector(31 downto 0);
	IF_pc		: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	IF_ID_instruction : out  std_logic_vector(31 downto 0);
   	IF_ID_pc        	: out std_logic_vector(31 downto 0));
  
end component;
component ID_EX_register
  generic (N : integer := 32);
  
  port(
   	ID_controller 	: in std_logic_vector(10 downto 0);
	ID_alu_controller: in std_logic_vector(12 downto 0);
	ID_reg_out_1 	: in std_logic_vector(31 downto 0);
	ID_reg_out_2	: in std_logic_vector(31 downto 0);
	ID_immediate	: in std_logic_vector(31 downto 0);
	ID_branch_logic	: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	ID_EX_controller 	: out std_logic_vector(10 downto 0);
	ID_EX_alu_controller	: out std_logic_vector(12 downto 0);
	ID_EX_reg_out_1 	: out std_logic_vector(31 downto 0);
	ID_EX_reg_out_2		: out std_logic_vector(31 downto 0);
	ID_EX_immediate		: out std_logic_vector(31 downto 0);
	ID_EX_branch_logic	: out std_logic_vector(31 downto 0));
  
end component;


component EX_MEM_register
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
  
end component;
component MEM_WB_register
  generic (N : integer := 32);
  
  port(
   	MEM_controller 		: in std_logic_vector(10 downto 0);
	MEM_alu_controller	: in std_logic_vector(12 downto 0);
	MEM_alu_out 		: in std_logic_vector(31 downto 0);
	MEM_data_mem_out	: in std_logic_vector(31 downto 0);
	MEM_branch_logic	: in std_logic_vector(31 downto 0);
	reset 		: in std_logic;
	clk		: in std_logic;
    	MEM_WB_controller 	: out std_logic_vector(10 downto 0);
	MEM_WB_alu_controller	: out std_logic_vector(12 downto 0);
	MEM_WB_alu_out	 	: out std_logic_vector(31 downto 0);
	MEM_WB_data_mem_out	: out std_logic_vector(31 downto 0);
	MEM_WB_branch_logic	: out std_logic_vector(31 downto 0));
  
end component;

--Signals for register file
signal s_write_data, ID_reg_out_1, ID_reg_out_2, ID_EX_reg_out_1, ID_EX_reg_out_2: std_logic_vector(31 downto 0);
signal s_write_address, s_write_address_final : std_logic_vector(4 downto 0);
--Signals for Data Memory
signal  s_mem_out, s_store_data: std_logic_vector(31 downto 0);
signal s_store_byteena: std_logic_vector(3 downto 0);
--Signals for Load
signal s_which_load : std_logic_vector(31 downto 0);
--Signals for PC and Instruction Memory
signal s_IF_instruction : std_logic_vector(31 downto 0);
-- Signal for Immediate
signal ID_immediate,ID_EX_immediate : std_logic_vector(31 downto 0);
--signals for ALU
signal s_alu_overflow, s_alu_c_out, s_alu_zero_out : std_logic;
signal s_input_2_alu, s_write_data_final: std_logic_vector(31 downto 0);
--signal for branch detection unit
signal s_take_branch, ID_EX_branch_logic: std_logic;
--signals for PC
signal  IF_ID_PC,IF_PC, s_link_address : std_logic_vector(31 downto 0);

signal s_load_is_And_Link, s_load_is_jump_reg : std_logic;


--CONTROL SIGNALS ALU
signal  ID_controller,ID_EX_controller: std_logic_vector(12 downto 0);

--CONTROL SIGNALS 
signal ID_alu_controller, ID_EX_alu_controller: std_logic_vector(1 downto 0);

begin

--PC Register
pc: PC_Register
  port MAP(
    PC_next =>s_PC_value,          
    PC_clk =>clk,
    PC_reset =>s_reset,
    PC_current =>s_current_PC_value);

--PC+4
pc_plus_4_i: pc_plus_4
  port MAP(
    a_input  =>s_current_PC_value,  
	s_reset=> s_reset,                                          
    o_output => IF_PC);
    
 --instruction memory
instuction_mem_i : instruction_mem
	port MAP  ( 	address	=>s_current_pc_value(11 downto 2),
			byteena	=>"0000",
			clock	=>clk,
			data	=>x"00000000",
			wren	=>'0',
			q	=> IF_instruction); 

entity IF_ID_register is
  generic (N : integer := 32);
  
  port(
   	IF_instruction=>IF_instruction,
	IF_pc=>IF_PC,
	reset=>s_reset,
	clk=>clk,
    	IF_ID_instruction=> IF_ID_instruction,
   	IF_ID_pc=>IF_ID_PC,
  
end IF_ID_register;


--ALU controller 
alu_control: alu_controller
	port MAP(	
		in_op_code => IF_ID_instruction(31 downto 26),
		in_function_code =>IF_ID_instruction(5 downto 0),
		in_sft_amount => IF_ID_instruction(10 downto 6),
		=> ID_alu_controller);

--Controller
control : controller 
	port MAP(
		in_op_code =>IF_ID_instruction(31 downto 26),
		in_function_code => IF_ID_instruction(5 downto 0),
		in_branch_code => IF_ID_instruction(20 downto 16),
		out_control => ID_controller);

 -- MUX - chooses rd or rt as the write register
rd_rt_write_register : mux_21_5_bit
	port MAP(
		i_X  =>IF_ID_instruction(15 downto 11),
		i_Y =>IF_ID_instruction(20 downto 16),
		s_1 =>ID_controller(11),		--load_rd_rt
		o_Z => s_write_address);

-- MUX - choosed whether write to register 31 or not
reg_write_address : mux_21_5_bit
	port MAP(
		i_X  =>s_write_address,
		i_Y => "11111",
		s_1 =>ID_controller(1),			--load_is_and_link
		o_Z => s_write_address_final);


--register file
reg_file : register_file  
port MAP (	
		i_reg1  => IF_ID_instruction(25 downto 21),
		i_reg2  => IF_ID_instruction(20 downto 16), 
		i_data => s_write_data_final,
		i_writereg  => s_write_address_final, 
		i_WE  => ID_controller(12)		--s_reg_write, 
		i_CLK  => clk,
		i_RST => s_reset,
		o_reg1  => ID_reg_out_1,
		o_reg2  => ID_reg_out_2);

-- Immediate - Chooses which immediate is loaded into the alu
choose_immediate_value :immediate
	port MAP(	
		in_immediate  => IF_ID_instruction(15 downto 0),
		in_upper_byte =>IF_ID_instruction(31 downto 16),
		load_which_immediate => ID_controller(9)		--s_load_which_immediate,
		out_immediate=> ID_immediate);

--branch logic
branch_log: branch_logic
  port MAP(
    PC_val   => IF_ID_PC,    -- PC + 4 value
    isJump => ID_controller(2)			--s_load_is_jump -- jump instruction when 1, branch otherwise
    branch_target => IF_ID_instruction(15 downto 0),         -- Lower 16 bits of instruction
    jump_target => IF_ID_instruction(25 downto 0),       -- Lower 26 bits of instruction
    isJump_reg => ID_controller(0),                             -- 1 when jr or jalr instruction ie opcode(instr(31:26)) of 0, func (instr(5:0)) of 001000 or 100010 respectively
    jump_reg  => ID_reg_out_1,         -- New PC value if jr or jalr instruction, read from reg file location specified by instr(25:21)
    PC_new   => s_new_PC_current,			         -- New PC value
    link_address => ID_branch_logic);        -- Old PC value for linking instructions



ID_EX_reg: ID_EX_register 
  port MAP(
   	ID_controller=>ID_controller,
	ID_alu_controller=>ID_alu_controller,
	ID_reg_out_1=>ID_reg_out_1,
	ID_reg_out_2=>ID_reg_out_2,
	ID_immediate=>ID_immediate,
	ID_branch_logic=>ID_branch_logic,
	reset=>s_reset,
	clk=>clk,
    	ID_EX_controller=>ID_EX_controller,
	ID_EX_alu_controller=>ID_EX_alu_controller,
	ID_EX_reg_out_1=>ID_EX_reg_out_1,
	ID_EX_reg_out_2=>ID_EX_reg_out_2,
	ID_EX_immediate=>ID_EX_immediate,
	ID_EX_branch_logic=>ID_EX_branch_logic);

--------STOPPPPPPPEDDDD HEEREREREREERERERE!!!!


--MUX - chooses whether the immediate value or regist file output goes into the ALU
o_reg2_immediate_alu_in : mux_21_n
	port MAP(
		i_X  =>s_reg_out_2,
		i_Y =>s_immediate_out,
		s_1 =>s_alu_src,
		o_Z => s_input_2_alu);


-- ALU
alu_mult_shifter : alu_mult_shift
	port MAP (
		a_in =>s_reg_out_1,
		b_in => s_input_2_alu, 
		op => s_op,
		add_sub => s_add_sub,
		load_type => s_load_type,
		sel_shift_v => s_sel_shift_v,
		shift_amount => s_instruction_out(10 downto 6),
		sel_srl_sll=> s_sel_srl_sll,
		sel_srl_sra => s_sel_srl_sra,
		load_alu_shift_mult => s_load_alu_shift_mult,
		result_out => s_alu_out,
		overflow => s_alu_overflow,
		zero_out => s_alu_zero_out,
		c_out 	=> s_alu_c_out);

 --data memory
data_mem : mem
	port MAP  ( 	address	=>s_alu_out(11 downto 2),
			byteena	=> s_store_byteena,
			clock	=>clk,
			data	=>s_store_data,
			wren	=>s_mem_write,
			q	=> s_mem_out); 
--load component
load_data :load
	port MAP (
		in_memory  => s_mem_out,
		load_which_load => s_load_which_load, 
		load_type_sign => s_type_sign,
		load_alu_out => s_alu_out(1 downto 0),
		out_load => s_which_load);

--store component
store_data: store
	port MAP
		(
		alu_in => s_alu_out,
		reg_out_2_in =>s_reg_out_2,
		load_size =>s_load_size,
		store_data=>s_store_data,
		store_byteena=>s_store_byteena);

-- MUX - choosed whether alu_out or s_which_load for write data register
alu_out_lw_write_data_register : mux_21_n
	port MAP(
		i_X  =>s_alu_out,
		i_Y =>s_which_load,
		s_1 =>ID_controller(10),		--s_mem_to_reg
		o_Z => s_write_data);

-- MUX - choosed whether link address or load/alu_out
link_address : mux_21_n
	port MAP(
		i_X  =>s_write_data,
		i_Y =>s_link_address,
		s_1 =>ID_controller(1),			--load_is_and_link
		o_Z => s_write_data_final);


--Branch Detection
branch_detection: branch_detection_Unit
  port MAP(
    instruction => s_instruction_out, 
    reg1  =>s_reg_out_1,
    reg2 =>s_reg_out_2,
    take_Branch => s_take_branch);

-- MUX - which pc value in used as pc current
which_pc_value: mux_21_n
	port MAP(
		i_X  =>s_pc_current,
		i_Y =>s_new_PC_current,
		s_1 =>s_take_branch,
		o_Z => s_PC_value);



end structure;