library IEEE;
use IEEE.std_logic_1164.all;
use work.all;

entity Eightto1Mux is
  port(
    input        :       in  std_logic_vector(7 downto 0);
    sel3         :       in  std_logic_vector(2 downto 0);
    output       :       out std_logic);
    
end Eightto1Mux;


architecture structure of Eightto1Mux is
  
begin
  
  with sel3 select
  
    output <= input(0)    when "000",
              input(1)    when "001",
              input(2)    when "010",
              input(3)    when "011",
              input(4)    when "100",
              input(5)    when "101",
              input(6)    when "110",
              input(7)    when "111",
                   '0'    when others;

end structure;
