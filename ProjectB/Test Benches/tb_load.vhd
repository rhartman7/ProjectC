library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_load is
end tb_load;

architecture behavior of tb_load is

-- Declare the component we are going to instantiate
component load
	port(	
		in_memory  : in std_logic_vector(31 downto 0);
		load_which_load : in std_logic_vector(1 downto 0);
		load_type_sign : in std_logic;
		load_alu_out : in std_logic_vector(1 downto 0);
		out_load: out std_logic_vector(31 downto 0));
end component;



-- Signals to connect to the struct_ones module
signal s_type_sign : std_logic;
signal s_which_load, s_load_alu_out : std_logic_vector(1 downto 0);
signal s_in_memory, s_result_out : std_logic_vector(31 downto 0);


begin

DUT: load
  port map(
		in_memory  => s_in_memory,
		load_which_load	 => s_which_load,
		load_type_sign => s_type_sign,
		load_alu_out => s_load_alu_out,
		out_load => s_result_out);
 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin

--lw
	s_in_memory  <= x"FFFFFFFF";
	s_which_load <= "00";
	s_type_sign <= '0';
	s_load_alu_out <= "00";
	wait for 100 ns;

--lh -- upper
	s_in_memory  <= x"FFFFEEEE";
	s_which_load <= "10";
	s_type_sign <= '0';
	s_load_alu_out <= "00";
	wait for 100 ns;

--lh -- lower
	s_in_memory  <= x"FFFFEEEE";
	s_which_load <= "10";
	s_type_sign <= '0';
	s_load_alu_out <= "10";
	wait for 100 ns;

--lhu -- upper
	s_in_memory  <= x"FFFFEEEE";
	s_which_load <= "10";
	s_type_sign <= '1';
	s_load_alu_out <= "00";
	wait for 100 ns;

--lhu -- lower
	s_in_memory  <= x"FFFFEEEE";
	s_which_load <= "10";
	s_type_sign <= '1';
	s_load_alu_out <= "10";
	wait for 100 ns;

--lb --upper 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '0';
	s_load_alu_out <= "00";
	wait for 100 ns;

--lb --middle left 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '0';
	s_load_alu_out <= "01";
	wait for 100 ns;

--lb --middle right 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '0';
	s_load_alu_out <= "10";
	wait for 100 ns;

--lb --lower 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '0';
	s_load_alu_out <= "11";
	wait for 100 ns;


--unsigned
--lbu --upper 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '1';
	s_load_alu_out <= "00";
	wait for 100 ns;

--lbu --middle left 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '1';
	s_load_alu_out <= "01";
	wait for 100 ns;

--lbu --middle right 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '1';
	s_load_alu_out <= "10";
	wait for 100 ns;

--lbu --lower 2 bytes
	s_in_memory  <= x"ABCD1234";
	s_which_load <= "01";
	s_type_sign <= '1';
	s_load_alu_out <= "11";
	wait;

  end process;
  
end behavior;
