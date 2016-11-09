library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity controller is
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
end controller;

architecture structure of controller is 

signal out_control,out_control_function_code, out_control_op_code, out_control_special_branch : std_logic_vector(12 downto 0);
begin
	with in_function_code select out_control_function_code <=
		--add
		"1000000000000" when "100000",
		--addu
	    	"1000000000000" when "100001",
		--sub
	    	"1000000000000" when "100010",
		--subu
	    	"1000000000000" when "100011",
		--and
		"1000000000000" when "100100",
		--or
	    	"1000000000000" when "100101",
		--xor
	    	"1000000000000" when "100110",
		--slt
	    	"1000000000000" when "101010",
		--sltu
	    	"1000000000000" when "101011",
		--sll
	    	"1000000000000" when "000000",
		--jr
	    	"0000000000110" when "001000",
		--jalr
	    	"0000000000111" when "001001",
		--srl
	    	"1000000000000" when "000010",
		--sra
	    	"1000000000000" when "000011",
		--sllv
	    	"1000000000000" when "000100",
		--srlv
	    	"1000000000000" when "000110",
		--srav
	    	"1000000000000" when "000111",
		--nor
	    	"1000000000000" when "100111",
		"1111111111111" when others;

		with in_op_code select out_control_op_code <=
		--addi
		"1100000000000" when "001000",
		--addiu
	    	"1100000000000" when "001001",
		--mul
		"1000000000000" when "010110",
		--andi
	    	"1100000000000" when "001100",
		--ori
	    	"1100000000000" when "001101",
		--xori
		"1100000000000" when "001110",
		--lb
	    	"1110000100000" when "100000",
		--lh
	    	"1110000010000" when "100001",
		--lw
	    	"1110000000000" when "100011",
		--lbu
	    	"1110000101000" when "100100",
		--lhu
	    	"1110000011000" when "100101",
		--sb
	    	"0100101000000" when "101000",
		--sh
	    	"0100110000000" when "101001",
		--sw
	    	"0100100000000" when "101011",
		--slti
	    	"1100000000000" when "001010",
		--sltiu
	    	"1100000000000" when "001011",
		--lui
	    	"1101000000000" when "001111",
		--j
	    	"0000000000100" when "000010",
		--jal
	    	"0000000000101" when "000011",
		--beq
	    	"0000000000000" when "000100",
		--bne
	    	"0000000000000" when "000101",
		--bltz, bqez, bltzal, bgezal
	    	"0000000000000" when "000001",
		--blez
	    	"0000000000000" when "000110",
		--bgtz
	    	"0000000000000" when "000111",
		"1111111111111" when others;

with in_branch_code select out_control_special_branch <=
		--bltz
	    	"0000000000000" when "00001",
		--bqez
		"0000000000000" when "00000",
		--bltzal
		"1000000000001" when "01010",
		--bgezal
		"1000000000001" when "01011",
		"1111111111111" when others;		


process (out_control, out_control_function_code, out_control_special_branch, out_control_op_code)
begin
if (in_op_code = "000000") then
out_control <= out_control_function_code;

elsif ( in_op_code = "000001") then
out_control <= out_control_special_branch;
else
out_control <= out_control_op_code;
end if;

end process;

reg_write <=out_control(12);
load_rd_rt <= out_control(11);
mem_to_reg <= out_control(10);
load_which_immediate <=out_control(9);
mem_write <= out_control(8);
load_size <= out_control(7 downto 6);
load_which_load <= out_control(5 downto 4);
load_type_sign <= out_control(3);
load_is_jump <= out_control(2);
load_is_And_Link <= out_control(1);
load_is_jump_reg <= out_control(0);





--reg_write <=out_control(0);
--load_rd_rt <= out_control(1);
--mem_to_reg <= out_control(2);
--load_which_immediate <=out_control(3);
--mem_write <= out_control(4);
--load_size <= out_control(6 downto 5);
--load_which_load <= out_control(8 downto 7);
--load_type_sign <= out_control(8);
--load_is_jump <= out_control(10);
--load_is_And_Link <= out_control(11);
--load_is_jump_reg <= out_control(12);





end structure;
