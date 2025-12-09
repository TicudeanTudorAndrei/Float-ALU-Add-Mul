library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity AllignerAdder is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
sum_exp: out STD_LOGIC_VECTOR(8 downto 0);
sum_sgn: out STD_LOGIC;
A_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
B_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
sum_mantissa: out STD_LOGIC_VECTOR(24 downto 0);  
nr_insignif: out STD_LOGIC);
end entity;

architecture AllignerAdder_Architecture of AllignerAdder is

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

component ShifterAdder is
Port ( mantissa_in : in STD_LOGIC_VECTOR(24 downto 0);
shift_amount: in STD_LOGIC_VECTOR(8 downto 0);
mantissa_out: out STD_LOGIC_VECTOR(24 downto 0));
end component;

-- mantissa / exponent / sign
signal A_mantissa, B_mantissa: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal A_exp, B_exp: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
signal A_sgn, B_sgn: STD_LOGIC := '0';
signal A_mantissa_shift, B_mantissa_shift: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');

-- exp difference signals
signal x_claa9b: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal exp_diff: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal two_comp_inp: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal two_comp_out: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal cin_claa9b, cout_claa9b: STD_LOGIC := '0'; 

begin	

-- extract sign / mantissa / exponent
A_sgn <= A(31);
A_exp <= "0" & A(30 downto 23);
A_mantissa <= "01" & A(22 downto 0);
B_sgn <= B(31);
B_exp <= "0" & B(30 downto 23);
B_mantissa <= "01" & B(22 downto 0);	
	
-- exp difference
EXPDIFF: CarryLookaheadAdder9b 
Port Map ( x => x_claa9b,
y => two_comp_out,
cin => cin_claa9b,
cout => cout_claa9b,
s => exp_diff);

TWOCOMPL: TwosComplement9b 
Port Map ( x => two_comp_inp,
x_2comp => two_comp_out);

-- shifters
SHIFTA: ShifterAdder
Port Map ( mantissa_in => A_mantissa,
shift_amount => exp_diff,
mantissa_out => A_mantissa_shift);

SHIFTB: ShifterAdder
Port Map ( mantissa_in => B_mantissa,
shift_amount => exp_diff,
mantissa_out => B_mantissa_shift);

-- verify which exp is bigger to avoid underflow
x_claa9b <= A_exp when unsigned(A_exp) > unsigned(B_exp) else
            B_exp;

two_comp_inp <= B_exp when unsigned(A_exp) > unsigned(B_exp) else
                A_exp;

-- allign mantissa
sum_exp <= A_exp when unsigned(A_exp) > unsigned(B_exp) else
           B_exp;
-- mantissa of the result or insignificance
sum_mantissa <= A_mantissa when unsigned(A_exp) > unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23 else
                B_mantissa when unsigned(A_exp) < unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23 else
                (others => '0');
-- sign of the result				
sum_sgn <= A_sgn when unsigned(A_exp) > unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23 else
           B_sgn when unsigned(A_exp) < unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23 else
           '0';
-- check if a number is insignificant based on exponent difference
nr_insignif <= '1' when (unsigned(A_exp) > unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23) or
                         (unsigned(A_exp) < unsigned(B_exp) and to_integer(unsigned(exp_diff)) > 23) else
         	   '0' when (unsigned(A_exp) > unsigned(B_exp) and to_integer(unsigned(exp_diff)) <= 23) or
                           (unsigned(A_exp) < unsigned(B_exp) and to_integer(unsigned(exp_diff)) <= 23) else
               '0'; -- A_exp = B_exp 

-- shift mantisas for alignment if needed
B_mantissa_out <= B_mantissa_shift when unsigned(A_exp) > unsigned(B_exp) and to_integer(unsigned(exp_diff)) <= 23 else
			  	  B_mantissa;  
A_mantissa_out <= A_mantissa_shift when unsigned(A_exp) < unsigned(B_exp) and to_integer(unsigned(exp_diff)) <= 23 else         
		      	  A_mantissa; 

end AllignerAdder_Architecture;
