library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_alu_32 is
end tb_alu_32;

architecture behavior of tb_alu_32 is

-- Declare the component we are going to instantiate
component ALU_32_bit
  	port(
		a_in  : in std_logic_vector(31 downto 0);
		b_in 	: in std_logic_vector(31 downto 0);
		op 	: in std_logic_vector(2 downto 0);
		c_in	: in std_logic;
		add_sub : in std_logic;
		load_type : in std_logic;
		result_out : out std_logic_vector(31 downto 0);
		overflow : out std_logic;
		zero_out : out std_logic;
		c_out 	: out std_logic);
end component;
 


-- Signals to connect to the struct_ones module
signal s_c_in, s_add_sub, s_load_type, s_overflow_out, s_zero_out, s_c_out : std_logic;
signal s_a_in, s_b_in, s_result_out : std_logic_vector(31 downto 0);
signal s_op_in : std_logic_vector(2 downto 0);

begin

DUT: alu_32_bit
  port map(
		a_in  => s_a_in,
		b_in 	 => s_b_in,
		op 	 => s_op_in,
		c_in	 => s_c_in,
		add_sub  => s_add_sub,
		load_type  => s_load_type,
		result_out => s_result_out,
		overflow  => s_overflow_out,
		zero_out  =>s_zero_out,
		c_out 	 => s_c_out);

 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin



	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "000";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';	
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "001";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "010";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;
	
	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "011";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "100";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "101";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "101";
	s_c_in <= '0';
	s_add_sub <= '1';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"FFFF0000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "110";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;

	s_a_in  <= x"00000000";
	s_b_in <= x"0000FFFF";
	s_op_in <= "110";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait for 100 ns;
	
	s_a_in  <= x"FFFFFFFF";
	s_b_in <= x"00000000";
	s_op_in <= "110";
	s_c_in <= '0';
	s_add_sub <= '0';
	s_load_type <='0';
	wait;


  end process;
  
end behavior;
