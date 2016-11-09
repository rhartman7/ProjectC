library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity mux_21 is
  	port(i_X  : in std_logic;
		i_Y: in std_logic;
		s_1 : in std_logic;
		o_Z : out std_logic);
end mux_21;

architecture structure of mux_21 is 

component inv
	port( i_A : in std_logic;
		o_F : out std_logic);
end component;

component or2 
port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;

component and2
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end component;


signal sVALUE_Aa, sVALUE_Ab, sVALUE_Ac : std_logic;

begin

g_invert: inv
    port MAP(
             i_A               => s_1,
             o_F               => sVALUE_Aa);

g_and1: and2
	port MAP(
             i_A               => sValue_Aa,
             i_B               => i_X,
		o_F => sVALUE_Ab);

g_and2: and2
	port MAP(
             i_A               => i_Y,
             i_B               => s_1,
		o_F => sVALUE_Ac);

g_or: or2
	port MAP(
             i_A               => sVALUE_Ab,
             i_B               => sVALUE_Ac,
		o_F => o_Z);



end structure;
