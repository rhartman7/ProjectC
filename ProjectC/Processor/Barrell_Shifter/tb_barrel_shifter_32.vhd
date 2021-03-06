library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_barrel_shift_32 is
end tb_barrel_shift_32;

architecture behavior of tb_barrel_shift_32 is

-- Declare the component we are going to instantiate
component barrel_shifter_32 
	
  	port(
		a_in  : in std_logic_vector(31 downto 0);
		sel_1 : in std_logic;
		sel_2 : in std_logic;
		sel_4 : in std_logic;
		sel_8 : in std_logic;
		sel_16 : in std_logic;
		sel_srl_sll : in std_logic;
		sel_srl_sra : in std_logic;
		output 	: out std_logic_vector(31 downto 0));
end component;
 


-- Signals to connect to the struct_ones module
signal s_sel_1, s_sel_2, s_sel_4, s_sel_8, s_sel_16, s_sel_srl_sra, s_sel_srl_sll : std_logic;
signal s_a_in, s_result_out : std_logic_vector(31 downto 0);


begin

DUT: barrel_shifter_32
  port map(
		a_in  => s_a_in,
		sel_1 	 => s_sel_1,
		sel_2 	 => s_sel_2,
		sel_4	 => s_sel_4,
		sel_8  => s_sel_8,
		sel_16  => s_sel_16,
		sel_srl_sra => s_sel_srl_sra,
		sel_srl_sll => s_sel_srl_sll,
		output 	 => s_result_out);

 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin

--shift one
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 2
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 4
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 8
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 16
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift all
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

---------- SRA

--shift one
	s_a_in  <= x"80000000";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '1';
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 2
	s_a_in  <= x"80000000";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '1';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 4
	s_a_in  <= x"80000000";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '1';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 8
	s_a_in  <= x"80000000";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '1';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 16
	s_a_in  <= x"80000000";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '1';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift all
	s_a_in  <= x"80000000";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '1';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

-------------SLL

--shift one
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';	
	wait for 100 ns;

--shift 2
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '1';	
	wait for 100 ns;

--shift 4
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift 8
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift 16
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift all
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '1';	
	wait for 100 ns ;


---------- Shift multiple

--shift 3
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 5
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 6
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

--shift 7
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 9
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 10
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 11
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;


--shift 11
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 12
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;


--shift 13
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;


--shift 14
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;

--shift 15
	s_a_in  <= x"FFFFFFFF";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '0';		
	wait for 100 ns;


--shift all
	s_a_in  <= x"80000000";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '1';	
	s_sel_srl_sll <= '0';	
	wait for 100 ns;

-------------SLL

--shift one
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '1';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';	
	wait for 100 ns;

--shift 2
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '1';	
	wait for 100 ns;

--shift 4
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '1';
	s_sel_8 <= '0';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift 8
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '1';
	s_sel_4 <= '0';
	s_sel_8 <= '1';
	s_sel_16 <= '0';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift 16
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '0';
	s_sel_2 <= '0';
	s_sel_4 <= '0';
	s_sel_8 <= '0';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';
	s_sel_srl_sll <= '1';		
	wait for 100 ns;

--shift all
	s_a_in  <= x"FFFFFFF0";
	s_sel_1 <= '1';
	s_sel_2 <= '1';
	s_sel_4 <= '1';
	s_sel_8 <= '1';
	s_sel_16 <= '1';
	s_sel_srl_sra <= '0';	
	s_sel_srl_sll <= '1';	
	wait;

  end process;
  
end behavior;
