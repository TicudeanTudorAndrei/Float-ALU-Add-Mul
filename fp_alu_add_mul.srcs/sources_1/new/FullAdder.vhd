library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FullAdder is
Port ( x: in STD_LOGIC;
y: in STD_LOGIC;
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC);
end entity;

architecture FullAdder_Architecture of FullAdder is

begin

s <= x xor y xor cin;
cout<= (x and y) or ((x or y) and cin);

end FullAdder_Architecture;