library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_control is
end tb_control;

architecture behavior of tb_control is

-- Declare the component we are going to instantiate
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


-- Signals to connect to the struct_ones module
signal s_reg_write,s_load_rd_rt, s_mem_to_reg, s_mem_write, s_load_which_immediate, s_load_is_jump, s_load_type_sign, s_load_is_jump_reg, s_load_is_And_Link : std_logic;
signal s_load_which_load, s_load_size: std_logic_vector(1 downto 0);
signal s_in_op_code, s_in_function_code: std_logic_vector(5 downto 0);
signal s_in_branch_code : std_logic_vector(4 downto 0);

begin

DUT: controller
  port map(
		in_op_code => s_in_op_code,
		in_function_code => s_in_function_code,
		in_branch_code => s_in_branch_code,
		reg_write => s_reg_write,
		load_rd_rt =>s_load_rd_rt,
		mem_to_reg =>s_mem_to_reg,
		load_which_immediate =>s_load_which_immediate,
		mem_write =>s_mem_write,
		load_size =>s_load_size,
		load_which_load =>s_load_which_load,
		load_is_jump =>s_load_is_jump,
		load_type_sign =>s_load_type_sign,
		load_is_jump_reg=> s_load_is_jump_reg,
		load_is_And_Link=> s_load_is_And_Link);

 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin


--add
	s_in_op_code <= "000000";
	s_in_function_code <="100000";
	wait for 100 ns;

--addu
	s_in_op_code <= "000000";
	s_in_function_code <="100001";
	wait for 100 ns;
--addi
	s_in_op_code <= "001000";
	s_in_function_code <="000000";
	wait for 100 ns;

--addiu
	s_in_op_code <= "001001";
	s_in_function_code <="000000";
	wait for 100 ns;

--sub
	s_in_op_code <= "000000";
	s_in_function_code <="100010";
	wait for 100 ns;

--subu
	s_in_op_code <= "000000";
	s_in_function_code <="100011";
	wait for 100 ns;

--mul
	s_in_op_code <= "010110";
	s_in_function_code <="000000";
	wait for 100 ns;
	
--and
	s_in_op_code <= "000000";
	s_in_function_code <="100100";
	wait for 100 ns;

--andi
	s_in_op_code <= "000000";
	s_in_function_code <="000000";
	wait for 100 ns;
--or
	s_in_op_code <= "000000";
	s_in_function_code <="100101";
	wait for 100 ns;
--ori
	s_in_op_code <= "001101";
	s_in_function_code <="000000";
	wait for 100 ns;

--xor
	s_in_op_code <= "000000";
	s_in_function_code <="100110";
	wait for 100 ns;

--xori
	s_in_op_code <= "001110";
	s_in_function_code <="000000";
	wait for 100 ns;
--nor
	s_in_op_code <= "000000";
	s_in_function_code <="100111";
	wait for 100 ns;

--lb
	s_in_op_code <= "100000";
	s_in_function_code <="000000";
	wait for 100 ns;
--lh
	s_in_op_code <= "100001";
	s_in_function_code <="000000";
	wait for 100 ns;
--lw
	s_in_op_code <= "100011";
	s_in_function_code <="000000";
	wait for 100 ns;
--lbu
	s_in_op_code <= "100100";
	s_in_function_code <="000000";
	wait for 100 ns;
--lhu
	s_in_op_code <= "100101";
	s_in_function_code <="000000";
	wait for 100 ns;
--sb
	s_in_op_code <= "101000";
	s_in_function_code <="000000";
	wait for 100 ns;
--sh
	s_in_op_code <= "101001";
	s_in_function_code <="000000";
	wait for 100 ns;
--sw
	s_in_op_code <= "101011";
	s_in_function_code <="000000";
	wait for 100 ns;
--slt
	s_in_op_code <= "000000";
	s_in_function_code <="101010";
	wait for 100 ns;
--slti
	s_in_op_code <= "001010";
	s_in_function_code <="000000";
	wait for 100 ns;
--sltiu
	s_in_op_code <= "001001";
	s_in_function_code <="000000";
	wait for 100 ns;
--sltu
	s_in_op_code <= "000000";
	s_in_function_code <="101011";
	wait for 100 ns;

--sll
	s_in_op_code <= "000000";
	s_in_function_code <="000000";
	wait for 100 ns;
--srl
	s_in_op_code <= "000000";
	s_in_function_code <="000010";
	wait for 100 ns;
 --sra
	s_in_op_code <= "000000";
	s_in_function_code <="000011";
	wait for 100 ns;
 --sllv
	s_in_op_code <= "000000";
	s_in_function_code <="000100";
	wait for 100 ns;
 --srlv
	s_in_op_code <= "000000";
	s_in_function_code <="000110";
	wait for 100 ns;
 --srav
	s_in_op_code <= "000000";
	s_in_function_code <="000111";
	wait for 100 ns;
 --jr
	s_in_op_code <= "000000";
	s_in_function_code <="001000";
	wait for 100 ns;
 --jalr
	s_in_op_code <= "000000";
	s_in_function_code <="001001";
	wait for 100 ns;
--j
	s_in_op_code <= "100100";
	s_in_function_code <="000000";
	wait for 100 ns;
--j
	s_in_op_code <= "000010";
	s_in_function_code <="000000";
	wait for 100 ns;
--jal
	s_in_op_code <= "000011";
	s_in_function_code <="000000";
	wait for 100 ns;
--beq
	s_in_op_code <= "000100";
	s_in_function_code <="000000";
	wait for 100 ns;
--bne
	s_in_op_code <= "000101";
	s_in_function_code <="000000";
	wait for 100 ns;
--bltz
	s_in_op_code <= "000001";
	s_in_function_code <="000000";
	s_in_branch_code <= "00001";
	wait for 100 ns;
--bgez
	s_in_op_code <= "000001";
	s_in_function_code <="000000";
	s_in_branch_code <= "00000";
	wait for 100 ns;
--bltzal
	s_in_op_code <= "000001";
	s_in_function_code <="000000";
	s_in_branch_code <= "01010";
	wait for 100 ns;
--bgezal
	s_in_op_code <= "000001";
	s_in_function_code <="000000";
	s_in_branch_code <= "01011";
	wait for 100 ns;
--blez
	s_in_op_code <= "000110";
	s_in_function_code <="000000";
	wait for 100 ns;
--bgtz
	s_in_op_code <= "000111";
	s_in_function_code <="000000";
	wait;

  end process;
end behavior;