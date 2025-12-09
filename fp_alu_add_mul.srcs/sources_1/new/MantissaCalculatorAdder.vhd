library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MantissaCalculatorAdder is
port( A_mantissa: in STD_LOGIC_VECTOR(24 downto 0);
B_mantissa: in STD_LOGIC_VECTOR(24 downto 0);
A_sgn: in STD_LOGIC;
B_sgn: in STD_LOGIC;
sum_mantissa: out STD_LOGIC_VECTOR(24 downto 0);
sum_sgn: out STD_LOGIC);
end entity;

architecture MantissaCalculatorAdder_Architecture of MantissaCalculatorAdder is
 
component CarryLookaheadAdder25b is
Port ( x: in STD_LOGIC_VECTOR(24 downto 0);
y: in STD_LOGIC_VECTOR(24 downto 0);
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC_VECTOR(24 downto 0));
end component;

component TwosComplement25b is
Port ( x: in STD_LOGIC_VECTOR(24 downto 0);
x_2comp: out STD_LOGIC_VECTOR(24 downto 0));
end component;

signal A_mantissa_2comp: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal B_mantissa_2comp: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal A_plus_B: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal A_minus_B: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal B_minus_A: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal cout1, cout2, cout3: STD_LOGIC := '0';

begin

B_TWOCOMPL: TwosComplement25b
port map( x => B_mantissa,
x_2comp => B_mantissa_2comp);

A_TWOCOMPL: TwosComplement25b
port map( x => A_mantissa,
x_2comp => A_mantissa_2comp);

ADD_AB: CarryLookaheadAdder25b
port map( x => A_mantissa,
y => B_mantissa,
cin => '0',
cout => cout1,
s => A_plus_B);

SUB_AB: CarryLookaheadAdder25b
port map( x => A_mantissa,
y => B_mantissa_2comp,
cin => '0',
cout => cout2,
s => A_minus_B);

SUB_BA: CarryLookaheadAdder25b
port map( x => B_mantissa,
y => A_mantissa_2comp,
cin => '0',
cout => cout3,
s => B_minus_A);

-- verify so there is no underflow
sum_mantissa <= A_plus_B when A_sgn = B_sgn else
                	 	 A_minus_B when unsigned(A_mantissa) >= unsigned(B_mantissa) else
                	     B_minus_A;

sum_sgn <= A_sgn when A_sgn = B_sgn or unsigned(A_mantissa) >= unsigned(B_mantissa) else
               	    B_sgn;

end MantissaCalculatorAdder_Architecture;
