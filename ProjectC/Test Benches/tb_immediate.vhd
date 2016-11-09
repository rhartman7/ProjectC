library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_immediate is
end tb_immediate;

architecture behavior of tb_immediate is

-- Declare the component we are going to instantiate
component immediate 
	port(	
		in_immediate  : in std_logic_vector(15 downto 0);
		in_upper_byte : in std_logic_vector(15 downto 0);
		load_which_immediate : in std_logic;
		out_immediate: out std_logic_vector(31 downto 0));
end component;



-- Signals to connect to the struct_ones module
signal s_which_immediate : std_logic;
signal s_in_immediate, s_in_upper_byte : std_logic_vector(15 downto 0);
signal s_out_immediate: std_logic_vector(31 downto 0);


begin

DUT: immediate
  port map(
		in_immediate => s_in_immediate,
		in_upper_byte => s_in_upper_byte,
		load_which_immediate => s_which_immediate,
		out_immediate=>s_out_immediate);
 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process

  begin

--regular immediate
	s_in_immediate  <= x"0FFF";
	s_in_upper_byte <= x"FFFF";
	s_which_immediate <= '0';
	wait for 100 ns;

--regular immediate sign extended
	s_in_immediate  <= x"FFFF";
	s_in_upper_byte <= x"FFFF";
	s_which_immediate <= '0';
	wait for 100 ns;


--load upper immediate
	s_in_immediate  <= x"0FFF";
	s_in_upper_byte <= x"FFFF";
	s_which_immediate <= '1';
	wait;

  end process;
  
end behavior;
