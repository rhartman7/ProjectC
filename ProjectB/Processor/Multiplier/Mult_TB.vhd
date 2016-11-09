library IEEE;
use IEEE.std_logic_1164.all;
use work.array2d.all;
use work.all;

entity Mult_TB is

end Mult_TB;

architecture behavior of Mult_TB is
  
  component Multiplier is
   port( 
      a_input       :       in  std_logic_vector(31 downto 0);
      b_input       :       in  std_logic_vector(31 downto 0);
      out_32        :       out std_logic_vector(31 downto 0));
   end component;
   
signal a_in, b_in, output         :       std_logic_vector(31 downto 0);

begin
  
  Mult: Multiplier
    port map(
      a_input         =>        a_in,
      b_input         =>        b_in,
      out_32          =>        output);
      
process
  begin
    
    a_in              <=        x"0000000F";
    b_in              <=        x"0000000F";
    wait for 200 ns;
    
    a_in              <=        x"0000000A";
    b_in              <=        x"0000000A";
    wait for 200 ns;
    
    a_in              <=        x"00000005";
    b_in              <=        x"0000000A";
    wait for 200 ns;
    
    a_in              <=        x"00000008";
    b_in              <=        x"00000005";
    wait for 200 ns;
    
    a_in              <=        x"00000009";
    b_in              <=        x"00000005";
    wait for 200 ns;
    
    a_in              <=        x"00000009";
    b_in              <=        x"00000007";
    wait for 200 ns;
    
    a_in              <=        x"00000004";
    b_in              <=        x"00000005";
    wait for 200 ns;
    
end process;
end behavior;