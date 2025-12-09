library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatingPointMultiplier is
port(A: in std_logic_vector(31 downto 0);
B: in std_logic_vector(31 downto 0);
clk: in std_logic;
reset: in std_logic;
start: in std_logic;
done: out std_logic;
product: out std_logic_vector(31 downto 0));
end entity;

architecture FloatingPointMultiplier_Architecture of FloatingPointMultiplier is

component EdgeCaseResolverMultiplier is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
product: out STD_LOGIC_VECTOR(31 downto 0);
edge_true: out STD_LOGIC);
end component;

component MatrixMultiplicator is
Port ( a: in STD_LOGIC_VECTOR(23 downto 0);
b: in STD_LOGIC_VECTOR(23 downto 0);
r: out STD_LOGIC_VECTOR(47 downto 0));
end component;

component ExpCalcMultiplier is
port( A_exp: in STD_LOGIC_VECTOR(8 downto 0);
B_exp: in STD_LOGIC_VECTOR(8 downto 0);
product_exp: out STD_LOGIC_VECTOR(8 downto 0));
end component;

type state_type is (WAIT_STATE, 
CHECK_INVALID_STATE, 
MUL_STATE, 
NORMALIZE_STATE, 
OUTPUT_STATE, 
DETECTED_INVALID_STATE);
signal state : state_type := WAIT_STATE;

signal A_sgn, B_sgn, result_sgn : std_logic;
signal A_exp, B_exp, result_exp : std_logic_vector(7 downto 0);
signal A_mantissa, B_mantissa : std_logic_vector(23 downto 0);
signal result_mantissa : std_logic_vector(47 downto 0);

-- special cases signals
signal A_edge, B_edge, product_edge: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal edge_case_true: STD_LOGIC := '0';

-- mantissa multiplication signals
signal A_mantissa_calc: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal B_mantissa_calc: STD_LOGIC_VECTOR(23 downto 0) := (others => '0');
signal R_mantissa : std_logic_vector(47 downto 0) := (others => '0');

-- exp calculator signals
signal A_exp_calc, B_exp_calc, product_exp_rez: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');

begin
-- resolve special cases
EDGECASE: EdgeCaseResolverMultiplier
PORT Map ( A => A_edge,
B => B_edge,
product => product_edge,
edge_true => edge_case_true);	

-- mantissa multiplier
MULTIPL: MatrixMultiplicator
Port Map ( a => A_mantissa_calc,
b => B_mantissa_calc,
r => R_mantissa);

-- exp calculator and bias
EXPCALC: ExpCalcMultiplier
Port Map ( A_exp => A_exp_calc,
B_exp => B_exp_calc,
product_exp => product_exp_rez);

process(clk, reset)
begin
	if reset = '1' then
    	state <= WAIT_STATE;
      	done <= '0';
      	product <= (others => '0');
    elsif rising_edge(clk) then
      	done <= '0';
      	case state is
        	when WAIT_STATE =>
          		if start = '1' then
            		-- decode input operands
            		A_sgn <= A(31);
            		B_sgn <= B(31);
            		A_exp <= A(30 downto 23);
            		B_exp <= B(30 downto 23);
            		A_mantissa <= '1' & A(22 downto 0);
            		B_mantissa <= '1' & B(22 downto 0);
           		
            		-- prepare edge case detection
					A_edge <= A;
					B_edge <= B;
					
					state <= CHECK_INVALID_STATE;
          		else
            		state <= WAIT_STATE;
          		end if;
				  
			-- resolve invalid cases state
			when CHECK_INVALID_STATE =>			
				if edge_case_true = '1' then
            		state <= DETECTED_INVALID_STATE;
          		else
					-- prepare multiplication
					A_mantissa_calc <= A_mantissa;
					B_mantissa_calc <= B_mantissa;
					
					-- prepare exp computation and bias
					A_exp_calc <= '0' & A_exp;
					B_exp_calc <= '0' & B_exp;
					state <= MUL_STATE;	  
			   	end if;
			
			-- compute mantissa / exp / sgn	+ normalize
        	when MUL_STATE =>
            	result_mantissa <= R_mantissa(46 downto 0) & '0';
            	result_exp <= product_exp_rez(7 downto 0);
            	result_sgn <= A_sgn XOR B_sgn;

            	state <= OUTPUT_STATE;
		
			-- return early when invalid state found
        	when DETECTED_INVALID_STATE =>
          		product <= product_edge;
          		done <= '1';
          		if start = '0' then
            		done <= '0';
            		state <= WAIT_STATE;
          		end if;
			
			-- normal output result  
        	when OUTPUT_STATE =>
          		product(31) <= result_sgn;
          		product(30 downto 23) <= result_exp;
          		product(22 downto 0) <= result_mantissa(47 downto 25);
          		done <= '1';
          		if start = '0' then
            		state <= WAIT_STATE;
          		end if;

        	when others =>
          		state <= WAIT_STATE;
      	end case;
    end if;
end process;

end FloatingPointMultiplier_Architecture;
