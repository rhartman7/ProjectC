library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity alu_controller is
	port(	
		in_op_code  : in std_logic_vector(5 downto 0);
		in_function_code : in std_logic_vector(5 downto 0);
		in_sft_amount : in std_logic_vector(4 downto 0);
		out_control : out std_logic_vector(10 downto 0));
end alu_controller;

architecture structure of alu_controller is 

signal out_control_function_code, out_control_op_code : std_logic_vector(10 downto 0);
begin

	with in_function_code select 
	out_control_function_code <="01010100000" when "100000",
		--addu
	    	"01010000000" when "100001",
		--sub
	    	"01011100000" when "100010",
		--subu
	    	"01011000000" when "100011",
		--and
		"00000100000" when "100100",
		--or
	    	"00010100000" when "100101",
		--xor
	    	"00100100000" when "100110",
		--slt
	    	"01100100000" when "101010",
		--sltu
	    	"01100000000" when "101011",
		--nor
	    	"01000100000" when "100111",
		--sll
	    	"00000100001" when "000000",
		--srl
	    	"00000110001" when "000010",
		--sra
	    	"00000101001" when "000011",
		--sllv
	    	"00000110101" when "000100",
		--srlv
	    	"00000100101" when "000110",
		--srav
	    	"00000101101" when "000111",
		"11111111111" when others;
		

		with in_op_code select 
out_control_op_code <= "11010100000" when "001000",
		--addiu
	    	"11010000000" when "001001",
		--andi
	    	"10000100000" when "001100",
		--mul
		"00000100010" when "010110",
		--ori
	    	"10010100000" when "001101",
		--xori
		"10100100000" when "001110",
		--lb
	    	"11010100000" when "100000",
		--lh
	    	"11010100000" when "100001",
		--lw
	    	"11010100000" when "100011",
		--lbu
	    	"11010000000" when "100100",
		--lhu
	    	"11010000000" when "100101",
		--sb
	    	"11010100000" when "101000",
		--sh
	    	"11010100000" when "101001",
		--sw
	    	"11010100000" when "101011",
		--slti
	    	"11100100000" when "001010",
		--sltiu
	    	"11100000000" when "001011",
		--lui
	    	"11010100000" when "001111",
		"11111111111" when others;

process (out_control_function_code, out_control_op_code)
begin
if (in_op_code = "000000") then
out_control <= out_control_function_code;

else
out_control <= out_control_op_code;

end if;
end process;

end structure;
