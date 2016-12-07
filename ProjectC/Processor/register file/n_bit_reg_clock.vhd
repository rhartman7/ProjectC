 -- a 32 bit register (structural)

library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity n_bit_reg_clock is
	generic(N : integer := 32);
	port(	i_CLK        : in std_logic;     -- Clock input
	       	i_RST        : in std_logic;     -- Reset input
	       	i_WE         : in std_logic;     -- Write enable input
	       	i_D          : in std_logic_vector(N-1 downto 0);     -- Data value input
	       	o_Q          : out std_logic_vector(N-1 downto 0));   -- Data value output

end n_bit_reg_clock;

architecture structure of n_bit_reg_clock is

	component dff
		  port(i_CLK        : in std_logic;     -- Clock input
		       i_RST        : in std_logic;     -- Reset input
		       i_WE         : in std_logic;     -- Write enable input
		       i_D          : in std_logic;     -- Data value input
		       o_Q          : out std_logic);   -- Data value output
	end component;

signal i_Clock : std_logic;	

begin
	--i_Clock <= '1' after 10ns when i_Clock = '0' else
		-- '0' after 10ns when i_Clock = '1';
i_Clock <= not(i_CLK);

	
	G1: for i in 0 to N-1 generate
		dff_1 : dff
			port map(	i_CLK => i_Clock,
					i_RST => i_RST,
					i_WE => i_WE,
					i_D => i_D(i),
					o_Q => o_Q(i)	);
	end generate;
	
end structure;
