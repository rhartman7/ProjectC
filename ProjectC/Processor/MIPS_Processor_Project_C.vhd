
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

component hazard_detection
  port(
    ex_mem_controller  : in std_logic_vector(12 downto 0);
    id_ex_controller   :   in std_logic_vector(12 downto 0);
    id_controller     : in std_logic_vector(12 downto 0);
    if_id_reset       : out std_logic;
    id_ex_RegRt       : in std_logic_vector(4 downto 0);
    id_ex_RegRs       : in std_logic_vector(4 downto 0);
    if_id_RegRt       : in std_logic_vector(4 downto 0);
    if_id_RegRs       : in std_logic_vector(4 downto 0);
    ex_mem_regRt       : in std_logic_vector(4 downto 0);
    ex_mem_stall             	     : out std_logic;
        s_reset            : in std_logic;
    id_ex_stall             	     : out std_logic;
    if_id_stall             	     : out std_logic;
    pc_stall             	     : out std_logic;
    take_Branch             : in std_logic;
    ex_mem_flush			         : out std_logic
--    id_ex_controller_out   : out std_logic_vector(12 downto 0)
	   );
  end component;
component forwarding is
  port(
    ex_mem_RegWen       : in  std_logic;                          -- WrEn EX/MEM
    mem_wb_RegWen       : in  std_logic;                          -- WrEn MEM/WB
    id_ex_instruction   : in  std_logic_vector(31 downto 0);      -- Instruction of ID/EX
    id_ex_RegRs         : in  std_logic_vector(4 downto 0);       -- Address of rs ID/EX
    id_ex_RegRt         : in  std_logic_vector(4 downto 0);       -- Address of rt ID/EX
    ex_mem_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd EX/MEM
    mem_wb_RegRd        : in  std_logic_vector(4 downto 0);       -- Address of rd MEM/WB
    ex_mem_RegRt        : in  std_logic_vector(4 downto 0);       -- Address of rt EX/MEM
    ex_mem_RegRs         : in  std_logic_vector(4 downto 0);       -- Address of rs EX/MEM
    mem_wb_RegRt        : in  std_logic_vector(4 downto 0);       -- Address pf rt MEM/WB
    is_Link             : in  std_logic;
    is_rd_rt_ex_mem     : in std_logic;
    is_rd_rt_mem_wb     : in std_logic;

    
    forwardA            : out std_logic_vector(2 downto 0);       -- when 000, first ALU operand from reg file
                                                                  -- when 001, first ALU operand forwarded from prior ALU result
                                                                  -- when 010, first ALU operand forwarded from DMEM or earlier ALU result
                                                                  -- when 011, Load hazard
                                                                  -- when 100, I-type instruction
                                                                  -- when 101, I-type 2 instructions later
    
    forwardB            : out std_logic_vector(2 downto 0));      -- when 000, second ALU operand from reg file
                                                                  -- when 001, second ALU operand forwarded from prior ALU result
                                                                  -- when 010, second ALU operand forwarded from DMEM or earlier ALU result
                                                                  -- when 011, Load hazard
                                                                  -- when 100, I-type instruction
                                                                  -- when 101, I-type 2 instructions later
end component;

component eightto1mux_32 is
  port(
    input_0        :       in  std_logic_vector(31 downto 0);
    input_1       :        in  std_logic_vector(31 downto 0);
    input_2        :       in  std_logic_vector(31 downto 0);
    input_3        :       in  std_logic_vector(31 downto 0);
    input_4        :       in  std_logic_vector(31 downto 0);
    input_5        :       in  std_logic_vector(31 downto 0);
    input_6        :       in  std_logic_vector(31 downto 0);
    input_7        :       in  std_logic_vector(31 downto 0);
    sel3         :       in  std_logic_vector(2 downto 0);
    output       :       out std_logic_vector(31 downto 0));
    
end component;

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

component mux_21_10_bit
	generic(N : integer := 10);
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

component mux_21_13_bit 
	generic(N : integer := 13);
  	port(i_X  : in std_logic_vector(N-1 downto 0);
		i_Y: in std_logic_vector(N-1 downto 0);
		s_1 : in std_logic;
		o_Z : out std_logic_vector(N-1 downto 0));
end component;

component mux_21
  	port(i_X  : in std_logic;
		i_Y: in std_logic;
		s_1 : in std_logic;
		o_Z : out std_logic);
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
		out_control : out std_logic_vector(10 downto 0));
end component;
--controller
component controller
	port(	
		in_op_code  : in std_logic_vector(5 downto 0);
		in_function_code : in std_logic_vector(5 downto 0);
		in_branch_code : in std_logic_vector(4 downto 0);
			out_control : out std_logic_vector(12 downto 0));

end component;

--PC and Branches

component PC_Register
  port(
    PC_next           :         in  std_logic_vector(31 downto 0);
    PC_clk            :         in  std_logic;
    PC_reset          :         in  std_logic;
    PC_write_en      :         in  std_logic;
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

--Signals for register file
signal s_write_data, ID_reg_out_1, ID_reg_out_2, ID_EX_reg_out_1, ID_EX_reg_out_2, EX_MEM_reg_out_2, EX_MEM_reg_out_1, MEM_WB_reg_out_2: std_logic_vector(31 downto 0);
signal s_write_address, s_write_address_final : std_logic_vector(4 downto 0);
--Signals for Data Memory
signal  MEM_data_mem_out, s_store_data, MEM_WB_data_mem_out: std_logic_vector(31 downto 0);
signal s_store_byteena: std_logic_vector(3 downto 0);
--Signals for Load
signal s_which_load : std_logic_vector(31 downto 0);
--Signals for PC and Instruction Memory
signal IF_instruction, IF_ID_instruction, ID_EX_instruction, EX_MEM_instruction, MEM_WB_instruction: std_logic_vector(31 downto 0);
--register write
signal EX_MEM_reg_write, MEM_WB_reg_write : std_logic_vector(4 downto 0);
-- Signal for Immediate
signal ID_immediate,ID_EX_immediate : std_logic_vector(31 downto 0);
--signals for ALU
signal EX_alu_out, EX_MEM_alu_out, MEM_WB_alu_out,  s_write_data_final, s_input_2_alu, s_ForwardA_out, s_ForwardB_out : std_logic_vector(31 downto 0);
signal s_alu_zero_out, s_alu_c_out,s_alu_overflow : std_logic;
--signal for branch detection unit
signal s_take_branch : std_logic;
--signals for PC
signal  IF_ID_PC, IF_PC, s_new_PC_current, s_PC_value, s_current_PC_value, s_pc_value_final      : std_logic_vector(31 downto 0); 
--brnach
signal ID_branch_logic, ID_EX_branch_logic, EX_MEM_branch_logic, MEM_WB_branch_logic  : std_logic_vector(31 downto 0);
-- forwarding signals
signal s_forwardA, s_forwardB     : std_logic_vector(2 downto 0);
--hazard detection
signal ex_mem_stall, id_ex_stall, if_id_stall, pc_stall, ex_mem_flush, IF_ID_reset, s_reset_final	: std_logic;


--CONTROL SIGNALS ALU
signal  ID_controller,ID_EX_controller, EX_MEM_controller, MEM_WB_controller, ID_controller_final : std_logic_vector(12 downto 0);

--CONTROL SIGNALS 
signal ID_alu_controller, ID_EX_alu_controller, EX_MEM_alu_controller, MEM_WB_alu_controller : std_logic_vector(10 downto 0);
signal s_load_store_mem_input : std_logic_vector(9 downto 0);

begin


-- MUX - which pc value in used as pc current
which_pc_value: mux_21_n
	port MAP(
		i_X  =>IF_PC,
		i_Y =>s_new_PC_current,
		s_1 =>s_take_branch,
		o_Z => s_PC_value);


--choosing which pc on a stall
mux_21_which_pc_on_stall: mux_21_n 	
  	port MAP
  	(i_X  => s_PC_value,
		i_Y  =>s_current_PC_value,
		s_1 => ex_mem_flush,
		o_Z => s_pc_value_final);


--PC Register
pc: PC_Register
  port MAP(
    PC_next =>s_pc_value_final, --s_pc_value,         
    PC_clk =>clk,
    PC_reset =>s_reset,
    PC_write_en=>pc_stall,         ---!!!!!!!
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
			
r_reset_mux_21 : mux_21
  	port MAP(
  	i_X  => IF_ID_reset,
		i_Y  => s_reset,
		s_1 => s_reset,
		o_Z => s_reset_final);


hi: IF_ID_register
  port MAP(   
   	IF_instruction=>IF_instruction,
	IF_pc=>IF_PC,
	reset=>s_reset_final,  --IF_ID_reset,--if_id_flush,
	wr_en =>if_id_stall,	----'1',                   ---!!!!!!!
	clk=>clk,
 	IF_ID_instruction=> IF_ID_instruction,
 	IF_ID_pc=>IF_ID_PC);
  



--ALU controller 
alu_control: alu_controller
	port MAP(	
		in_op_code => IF_ID_instruction(31 downto 26),
		in_function_code =>IF_ID_instruction(5 downto 0),
		in_sft_amount => IF_ID_instruction(10 downto 6),
		out_control => ID_alu_controller);

--Controller
control : controller 
	port MAP(
		in_op_code =>IF_ID_instruction(31 downto 26),
		in_function_code => IF_ID_instruction(5 downto 0),
		in_branch_code => IF_ID_instruction(20 downto 16),
		out_control => ID_controller);

--register file
reg_file : register_file  
port MAP (	
		i_reg1  => IF_ID_instruction(25 downto 21),
		i_reg2  => IF_ID_instruction(20 downto 16), 
		i_data => s_write_data_final,
		i_writereg  =>MEM_WB_reg_write, 
		i_WE  => MEM_WB_controller(12),		--s_reg_write, 
		i_CLK  => clk,
		i_RST => s_reset,
		o_reg1  => ID_reg_out_1,
		o_reg2  => ID_reg_out_2);

-- Immediate - Chooses which immediate is loaded into the alu
choose_immediate_value :immediate
	port MAP(	
		in_immediate  => IF_ID_instruction(15 downto 0),
		in_upper_byte =>IF_ID_instruction(15 downto 0),
		load_which_immediate => ID_controller(9),		--s_load_which_immediate,
		out_immediate=> ID_immediate);

--branch logic
branch_log: branch_logic
  port MAP(
    PC_val   => IF_ID_PC,    -- PC + 4 value
    isJump => ID_controller(2),			--s_load_is_jump -- jump instruction when 1, branch otherwise
    branch_target => IF_ID_instruction(15 downto 0),         -- Lower 16 bits of instruction
    jump_target => IF_ID_instruction(25 downto 0),       -- Lower 26 bits of instruction
    isJump_reg => ID_controller(1),                             -- 1 when jr or jalr instruction ie opcode(instr(31:26)) of 0, func (instr(5:0)) of 001000 or 100010 respectively
    jump_reg  => ID_reg_out_1,         -- New PC value if jr or jalr instruction, read from reg file location specified by instr(25:21)
    PC_new   => s_new_PC_current,			         -- New PC value
    link_address => ID_branch_logic);        -- Old PC value for linking instructions


--Branch Detection
branch_detection: branch_detection_Unit
  port MAP(
    instruction => IF_ID_instruction, 
    reg1  =>ID_reg_out_1,
    reg2 =>ID_reg_out_2,
    take_Branch => s_take_branch);

haz_detection :  hazard_detection
  port MAP(
        ex_mem_controller  => EX_MEM_controller,
        id_ex_controller   => ID_EX_controller,
    id_controller     =>  ID_controller,
    if_id_reset       =>  IF_ID_reset,
    id_ex_RegRt     =>  ID_EX_instruction(20 downto 16),
    id_ex_RegRs       => ID_EX_instruction(25 downto 21),
    if_id_RegRt       =>  IF_ID_instruction(20 downto 16),
    if_id_RegRs       =>  IF_ID_instruction(25 downto 21),
    ex_mem_regRt       => EX_MEM_instruction(20 downto 16),
    ex_mem_stall       => ex_mem_stall,
        s_reset        => s_reset,
    id_ex_stall        => id_ex_stall,
    if_id_stall     => if_id_stall,
    pc_stall        => pc_stall,
    take_Branch             => s_take_branch,
    ex_mem_flush			     => ex_mem_flush
--    id_ex_controller_out => ID_controller_final
);

mux_21_13: mux_21_13_bit 	
  	port MAP
  	(i_X  => ID_controller,
		i_Y  => "0000000000000",
		s_1 => ex_mem_flush,
		o_Z => ID_controller_final);


ID_EX_reg: ID_EX_register 
  port MAP(
    ID_controller=>ID_controller_final,
	ID_alu_controller=>ID_alu_controller,
	ID_reg_out_1=>ID_reg_out_1,
	ID_reg_out_2=>ID_reg_out_2,
	ID_immediate=>ID_immediate,
	ID_instruction=>IF_ID_instruction,
	ID_branch_logic=> ID_branch_logic,
	reset=>s_reset,
	clk=>clk,
	ID_EX_we  => '1',            --   id_ex_stall,
    	ID_EX_controller=>ID_EX_controller,
	ID_EX_alu_controller=>ID_EX_alu_controller,
	ID_EX_reg_out_1=>ID_EX_reg_out_1,
	ID_EX_reg_out_2=>ID_EX_reg_out_2,
	ID_EX_immediate=>ID_EX_immediate,
	ID_EX_instruction=>ID_EX_instruction,
	ID_EX_branch_logic=>ID_EX_branch_logic);

forward_logic: forwarding
  port MAP(
    ex_mem_RegWen       => EX_MEM_controller(12),                          -- WrEn EX/MEM
    mem_wb_RegWen       => MEM_WB_controller(12),                        -- WrEn MEM/WB
    id_ex_instruction   => ID_EX_instruction,      -- Instruction of ID/EX
    id_ex_RegRs         => ID_EX_instruction(25 downto 21),                              -- Address of rs ID/EX
    id_ex_RegRt         => ID_EX_instruction(20 downto 16),                             -- Address of rt ID/EX
    ex_mem_RegRd        => EX_MEM_instruction(15 downto 11),      -- Address of rd EX/MEM
    mem_wb_RegRd        => MEM_WB_instruction(15 downto 11),      -- Address of rd MEM/WB
    ex_mem_RegRt        => EX_MEM_instruction(20 downto 16),
    ex_mem_RegRs        => EX_MEM_instruction(25 downto 21),
    mem_wb_RegRt        => MEM_WB_instruction(20 downto 16),
    is_Link             => EX_MEM_controller(1),
    is_rd_rt_ex_mem     => EX_MEM_controller(11),
    is_rd_rt_mem_wb     => MEM_WB_controller(11),

    
    forwardA            => s_ForwardA,                            -- when 00, first ALU operand from reg file
                                                                  -- when 10, first ALU operand forwarded from prior ALU result
                                                                  -- when 01, first ALU operand forwarded from DMEM or earlier ALU result
    
    forwardB            => s_forwardB);                           -- when 00, second ALU operand from reg file
                                                                  -- when 10, second ALU operand forwarded from prior ALU result
                                                                  -- when 01, second ALU operand forwarded from DMEM or earlier ALU result

--MUX - chooses whether the immediate value or regist file output goes into the ALU
o_reg2_immediate_alu_in : mux_21_n
	port MAP(
		i_X  =>ID_EX_reg_out_2,
		i_Y =>ID_EX_immediate,
		s_1 =>ID_EX_alu_controller(10),			--s_alu_src,
		o_Z => s_input_2_alu);
		
-- ALU IN Mux A
ALU_in_A: eightto1mux_32
  port MAP(
    input_0        => ID_EX_reg_out_1,
    input_1        => EX_MEM_alu_out,
    input_2        => MEM_WB_alu_out,
    input_3        => s_which_load,
    input_4        => EX_MEM_alu_out,
    input_5        => MEM_WB_alu_out,
    input_6        => ID_branch_logic,
    input_7        => x"00000000",
    sel3           => s_ForwardA,
    output         => s_ForwardA_out);
    
-- ALU IN Mux B
ALU_in_B: eightto1mux_32
  port MAP(
    input_0        => s_input_2_alu,
    input_1        => EX_MEM_alu_out,
    input_2        => MEM_WB_alu_out,
    input_3        => s_which_load,
    input_4        => EX_MEM_alu_out,
    input_5        => MEM_WB_alu_out,
    input_6        => ID_branch_logic,
    input_7        => x"00000000",
    sel3           => s_ForwardB,
    output         => s_ForwardB_out);
    



-- ALU
alu_mult_shifter : alu_mult_shift
	port MAP (
		a_in =>s_ForwardA_out,
		b_in => s_ForwardB_out, 
		op => ID_EX_alu_controller(9 downto 7),		--s_op,
		add_sub => ID_EX_alu_controller(6),		--s_add_sub,
		load_type => ID_EX_alu_controller(5),		--s_load_type,
		sel_shift_v => ID_EX_alu_controller(2),		--s_sel_shift_v,
		shift_amount => ID_EX_instruction(10 downto 6),
		sel_srl_sll=> ID_EX_alu_controller(4),		--s_sel_srl_sll,
		sel_srl_sra => ID_EX_alu_controller(3),		--s_sel_srl_sra,
		load_alu_shift_mult => ID_EX_alu_controller(1 downto 0),		--s_load_alu_shift_mult,
		result_out =>	EX_alu_out,
		overflow => s_alu_overflow,
		zero_out => s_alu_zero_out,
		c_out 	=> s_alu_c_out);

 -- MUX - chooses rd or rt as the write register
rd_rt_write_register : mux_21_5_bit
	port MAP(
		i_X  =>ID_EX_instruction(15 downto 11),
		i_Y =>ID_EX_instruction(20 downto 16),
		s_1 =>ID_EX_controller(11),		--load_rd_rt
		o_Z => s_write_address);

-- MUX - choosed whether write to register 31 or not
reg_write_address : mux_21_5_bit
	port MAP(
		i_X  =>s_write_address,
		i_Y => "11111",
		s_1 =>ID_EX_controller(1),			--load_is_and_link
		o_Z => s_write_address_final);



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
	reset 			=> s_reset,        --ex_mem_flush,       --!!!!!!!!!!!!!!!!!!!!
	clk			=>clk,
	EX_MEM_we   => '1',   --!!!!!!!!!!!!!!!!!!!
	EX_MEM_instruction => EX_MEM_instruction,
    	EX_MEM_controller 	=>EX_MEM_controller,
	EX_MEM_alu_controller	=>EX_MEM_alu_controller,
	EX_MEM_alu_out	 	=>EX_MEM_alu_out,
	EX_MEM_reg_out_2	=>EX_MEM_reg_out_2,
	EX_MEM_reg_out_1 => EX_MEM_reg_out_1,
	EX_MEM_branch_logic	=>EX_MEM_branch_logic,
	EX_MEM_reg_write	=>EX_MEM_reg_write);


 --store component
store_data: store
	port MAP
		(
		alu_in => MEM_WB_alu_out,
		reg_out_2_in =>EX_MEM_reg_out_2,
		load_size =>EX_MEM_controller(6 downto 5),		--s_load_size,
		store_data=>s_store_data,
		store_byteena=>s_store_byteena);

-- MUX - which value goes into memory
which_memory_input: mux_21_10_bit
	port MAP(
		i_X  =>EX_MEM_alu_out(11 downto 2),
		i_Y =>MEM_WB_alu_out(11 downto 2),
		s_1 =>EX_MEM_controller(8),
		o_Z => s_load_store_mem_input);
 --data memory
data_mem : mem
	port MAP  ( 	address	=>s_load_store_mem_input,--EX_MEM_alu_out(11 downto 2),--
			byteena	=> s_store_byteena,
			clock	=>clk,
			data	=>s_store_data,
			wren	=>EX_MEM_controller(8),       --s_write
			q	=> MEM_data_mem_out); 

MEM_WB_reg: MEM_WB_register

  port MAP(
    MEM_instruction => EX_MEM_instruction,
   	MEM_controller 		=>EX_MEM_controller,
	MEM_alu_controller	=>EX_MEM_alu_controller,
	MEM_alu_out 		=>EX_MEM_alu_out,
	MEM_data_mem_out	=>   MEM_data_mem_out,
	MEM_branch_logic	=>EX_MEM_branch_logic, 
	MEM_reg_write		=>EX_MEM_reg_write,
	MEM_reg_out_2 => EX_MEM_reg_out_2,
	reset 		=>s_reset,
	clk		=>clk,
	MEM_WB_we	=>'1',
	MEM_WB_instruction => MEM_WB_instruction,
	MEM_WB_reg_out_2 => MEM_WB_reg_out_2,
    	MEM_WB_controller 	=>MEM_WB_controller ,
	MEM_WB_alu_controller	=>MEM_WB_alu_controller ,
	MEM_WB_alu_out	 	=>MEM_WB_alu_out,
	MEM_WB_data_mem_out	=>MEM_WB_data_mem_out,
	MEM_WB_branch_logic	=>MEM_WB_branch_logic,
	MEM_WB_reg_write	=>MEM_WB_reg_write);


--load component
load_data :load
	port MAP (
		in_memory  => MEM_data_mem_out,
		load_which_load => MEM_WB_controller(5 downto 4),		--s_load_which_load, 
		load_type_sign => MEM_WB_controller(3),				--s_type_sign,
		load_alu_out => MEM_WB_alu_out(1 downto 0),
		out_load => s_which_load);


-- MUX - choosed whether alu_out or s_which_load for write data register
alu_out_lw_write_data_register : mux_21_n
	port MAP(
		i_X  =>MEM_WB_alu_out,
		i_Y =>  s_which_load,
		s_1 =>MEM_WB_controller(10),		--s_mem_to_reg
		o_Z => s_write_data);

-- MUX - choosed whether link address or load/alu_out
link_address : mux_21_n
	port MAP(
		i_X  =>s_write_data,
		i_Y =>MEM_WB_branch_logic,
		s_1 =>MEM_WB_controller(1),			--load_is_and_link
		o_Z => s_write_data_final);



end structure;