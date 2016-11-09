library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

-- This is an empty entity so we don't need to declare ports
entity tb_MIPS_Processor_b is
end tb_MIPS_Processor_b;

architecture behavior of tb_MIPS_Processor_b is

-- Declare the component we are going to instantiate
component MIPS_Processor_Project_B is
  	generic(N : integer := 32);
	port(	
		clk : in std_logic);
end component;

-- Signals to connect to the struct_ones module
signal s_clk : std_logic; 


begin

DUT: MIPS_Processor_Project_B
  port map(clk => s_clk);

 

  -- Remember, a process executes sequentially
  -- and then if not told to 'wait' loops back
  -- around
  tester : process


  begin

	wait 100 ns;
  end process;
end behavior;