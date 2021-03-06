library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_store is
end tb_store;

architecture behavior of tb_store is

-- Declare the component we are going to instantiate
component store
		port(
		alu_in : in std_logic_vector(31 downto 0);
		reg_out_2_in : in std_logic_vector(31 downto 0);
		load_size : in std_logic_vector(1 downto 0);
		store_data: out std_logic_vector(31 downto 0);
		store_byteena: out std_logic_vector(3 downto 0));
end component;



-- Signals to connect to the struct_ones module
signal s_store_byteena : std_logic_vector(3 downto 0);
signal s_load_size : std_logic_vector(1 downto 0);
signal s_alu_in, s_reg_out_2_in, s_store_data : std_logic_vector(31 downto 0);


begin

DUT: store
  port map(
		alu_in => s_alu_in,
		reg_out_2_in => s_reg_out_2_in,
		load_size => s_load_size,
		store_data => s_store_data ,
		store_byteena =>s_store_byteena );
 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin

--sw
	s_alu_in  <= x"ABCD1234";
	s_reg_out_2_in <= x"FFFFFFF0";
	s_load_size <= "00";
	wait for 100 ns;

--sb --0000
	s_alu_in  <= x"ABCD1230";
	s_reg_out_2_in <= x"FFFFFFF0";
	s_load_size <= "01";
	wait for 100 ns;

--sb --0001
	s_alu_in  <= x"ABCD1231";
	s_reg_out_2_in <= x"FFFFFFF1";
	s_load_size <= "01";
	wait for 100 ns;

--sb --0010
	s_alu_in  <= x"ABCD1232";
	s_reg_out_2_in <= x"FFFFFFF2";
	s_load_size <= "01";
	wait for 100 ns;
--sb --0011
	s_alu_in  <= x"ABCD1233";
	s_reg_out_2_in <= x"FFFFFFF3";
	s_load_size <= "01";
	wait for 100 ns;

--sh --0011
	s_alu_in  <= x"ABCD1234";
	s_reg_out_2_in <= x"FFFFFFF1";
	s_load_size <= "10";
	wait for 100 ns;

--sh --1100
	s_alu_in  <= x"ABCD1234";
	s_reg_out_2_in <= x"FFFFFFF3";
	s_load_size <= "10";
	wait for 100 ns;


	wait;

  end process;
  
end behavior;