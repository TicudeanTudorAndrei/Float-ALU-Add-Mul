library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ExpCalcMultiplier is
port( A_exp: in STD_LOGIC_VECTOR(8 downto 0);
B_exp: in STD_LOGIC_VECTOR(8 downto 0);
product_exp: out STD_LOGIC_VECTOR(8 downto 0));
end entity;

architecture ExpCalcMultiplier_Architecture of ExpCalcMultiplier is

component CarryLookaheadAdder9b is
Port ( x: in STD_LOGIC_VECTOR (8 downto 0);
y: in STD_LOGIC_VECTOR (8 downto 0);
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC_VECTOR (8 downto 0));
end component;

component TwosComplement9b is
Port ( x: in STD_LOGIC_VECTOR (8 downto 0);
x_2comp: out STD_LOGIC_VECTOR (8 downto 0));
end component;

signal nr126: STD_LOGIC_VECTOR(8 downto 0) := "001111110";
signal twocompl_nr126: STD_LOGIC_VECTOR(8 downto 0) := "110000010";
signal cout1, cout2: STD_LOGIC := '0';

signal interm: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');

begin	
	
-- exp computation
ADDER1: CarryLookaheadAdder9b 
Port Map ( x => A_exp,
y => B_exp,
cin => '0',
cout => cout1,
s => interm);

ADDER2: CarryLookaheadAdder9b 
Port Map ( x => interm,
y => twocompl_nr126,
cin => '0',
cout => cout2,
s => product_exp);

end ExpCalcMultiplier_Architecture;
