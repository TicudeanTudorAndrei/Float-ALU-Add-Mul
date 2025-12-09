library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MantissaNormalizerAdder is
port( sum_mantissa_in: in STD_LOGIC_VECTOR(24 downto 0);
sum_exp_in: in STD_LOGIC_VECTOR(8 downto 0);
sum_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
sum_exp_out: out STD_LOGIC_VECTOR(8 downto 0));
end entity;

architecture MantissaNormalizerAdder_Architecture of MantissaNormalizerAdder is

component CarryLookaheadAdder9b is
Port ( x: in STD_LOGIC_VECTOR (8 downto 0);
y: in STD_LOGIC_VECTOR (8 downto 0);
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC_VECTOR (8 downto 0));
end component;

signal one: STD_LOGIC_VECTOR(8 downto 0) := "000000001";
signal twoscomp_one: STD_LOGIC_VECTOR(8 downto 0) := "111111111";

signal expplusone: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal expminusone: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal two_comp_inp: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal two_comp_out: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal cout1, cout2: STD_LOGIC := '0';

begin

EXPPLUS: CarryLookaheadAdder9b 
Port Map ( x => sum_exp_in,
y => one,
cin => '0',
cout => cout1,
s => expplusone);

EXPMINUS: CarryLookaheadAdder9b 
Port Map ( x => sum_exp_in,
y => twoscomp_one,
cin => '0',
cout => cout2,
s => expminusone);

-- mantissa normalization and overflow handling
sum_mantissa_out <= (others => '0') when (unsigned(sum_mantissa_in) = 0) else
    			    '0' & sum_mantissa_in(24 downto 1) when (sum_mantissa_in(24) = '1') else  -- overflow (shift left)
                    sum_mantissa_in(23 downto 0) & '0' when (sum_mantissa_in(23) = '0') else  -- underflow (shift right)
    				sum_mantissa_in;

-- adjust the exponent based on mantissa normalization
sum_exp_out <= (others => '0') when (unsigned(sum_mantissa_in) = 0) else
    		   expplusone when (sum_mantissa_in(24) = '1') else  -- mantissa overflow
    		   expminusone when (sum_mantissa_in(23) = '0') else  -- mantissa underflow
    	       sum_exp_in;

end MantissaNormalizerAdder_Architecture;
