-- array of 32 std_logic_vector of size 32

library IEEE;
use IEEE.std_logic_1164.all;

package array_of_vectors_32_type is
	type arrayVectors32 is array(0 to 31) of std_logic_vector(31 downto 0);
end package array_of_vectors_32_type;
