library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_alu_control is
end tb_alu_control;

architecture behavior of tb_alu_control is

-- Declare the component we are going to instantiate
component alu_controller
	port(	
		in_op_code  : in std_logic_vector(5 downto 0);
		in_function_code : in std_logic_vector(5 downto 0);
		in_sft_amount : in std_logic_vector(4 downto 0);
		out_control : out std_logic_vector(10 downto 0));
end component;


-- Signals to connect to the struct_ones module
signal s_out_control : std_logic_vector(10 downto 0);
signal s_in_op_code, s_in_function_code: std_logic_vector(5 downto 0);
signal s_in_sft_amount: std_logic_vector(4 downto 0);


begin

DUT: alu_controller
  port map(
		in_op_code => s_in_op_code, 
		in_function_code => s_in_function_code, 
		in_sft_amount => s_in_sft_amount, 
		out_control => s_out_control);

 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin


--add
	s_in_op_code <= "000000";
	s_in_function_code <="100000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--addu
	s_in_op_code <= "000000";
	s_in_function_code <="100001";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--addi
	s_in_op_code <= "001000";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--addiu
	s_in_op_code <= "001001";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--sub
	s_in_op_code <= "000000";
	s_in_function_code <="100010";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--subu
	s_in_op_code <= "000000";
	s_in_function_code <="100011";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--mul
	s_in_op_code <= "010110";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
	
--and
	s_in_op_code <= "000000";
	s_in_function_code <="100100";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--andi
	s_in_op_code <= "000000";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--or
	s_in_op_code <= "000000";
	s_in_function_code <="100101";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--ori
	s_in_op_code <= "001101";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--xor
	s_in_op_code <= "000000";
	s_in_function_code <="100110";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--xori
	s_in_op_code <= "001110";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--nor
	s_in_op_code <= "000000";
	s_in_function_code <="100111";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--lb
	s_in_op_code <= "100000";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--lh
	s_in_op_code <= "100001";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--lw
	s_in_op_code <= "100011";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--lbu
	s_in_op_code <= "100100";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--lhu
	s_in_op_code <= "100101";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--sb
	s_in_op_code <= "101000";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--sh
	s_in_op_code <= "101001";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--sw
	s_in_op_code <= "101011";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--slt
	s_in_op_code <= "000000";
	s_in_function_code <="101010";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--slti
	s_in_op_code <= "001010";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--sltiu
	s_in_op_code <= "001001";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--sltu
	s_in_op_code <= "000000";
	s_in_function_code <="101011";
	s_in_sft_amount <= "00000";
	wait for 100 ns;

--sll
	s_in_op_code <= "000000";
	s_in_function_code <="000000";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
--srl
	s_in_op_code <= "000000";
	s_in_function_code <="000010";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
 --sra
	s_in_op_code <= "000000";
	s_in_function_code <="000011";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
 --sllv
	s_in_op_code <= "000000";
	s_in_function_code <="000100";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
 --srlv
	s_in_op_code <= "000000";
	s_in_function_code <="000110";
	s_in_sft_amount <= "00000";
	wait for 100 ns;
 --srav
	s_in_op_code <= "000000";
	s_in_function_code <="000111";
	s_in_sft_amount <= "00000";
	wait;
  end process;
end behavior;