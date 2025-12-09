library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FloatingPointAdder is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
clk: in STD_LOGIC;
reset: in STD_LOGIC;
start: in STD_LOGIC;
done: out STD_LOGIC;
sum: out STD_LOGIC_VECTOR(31 downto 0));
end entity;

architecture FloatingPointAdder_Architecture of FloatingPointAdder is

component EdgeCaseResolverAdder is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
sum: out STD_LOGIC_VECTOR(31 downto 0);
edge_true: out STD_LOGIC);
end component;

component AllignerAdder is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
sum_exp: out STD_LOGIC_VECTOR(8 downto 0);
sum_sgn: out STD_LOGIC;
A_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
B_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
sum_mantissa: out STD_LOGIC_VECTOR(24 downto 0);  
nr_insignif: out STD_LOGIC);
end component;

component MantissaCalculatorAdder is
port( A_mantissa: in STD_LOGIC_VECTOR(24 downto 0);
B_mantissa: in STD_LOGIC_VECTOR(24 downto 0);
A_sgn: in STD_LOGIC;
B_sgn: in STD_LOGIC;
sum_mantissa: out STD_LOGIC_VECTOR(24 downto 0);
sum_sgn: out STD_LOGIC);
end component;

component MantissaNormalizerAdder is
port( sum_mantissa_in: in STD_LOGIC_VECTOR(24 downto 0);
sum_exp_in: in STD_LOGIC_VECTOR(8 downto 0);
sum_mantissa_out: out STD_LOGIC_VECTOR(24 downto 0);
sum_exp_out: out STD_LOGIC_VECTOR(8 downto 0));
end component;

-- states
type ST is ( WAIT_STATE, 
CHECK_INVALID_STATE,
DETECTED_INVALID_STATE,
ALLIGN_STATE, 
ADDITION_STATE, 
NORMALIZE_STATE, 
OUTPUT_STATE);

signal state: ST := WAIT_STATE;

-- mantissa / exponent / sign
signal A_mantissa, B_mantissa: STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
signal A_exp, B_exp: STD_LOGIC_VECTOR(8 downto 0) := (others => '0');
signal A_sgn, B_sgn: STD_LOGIC := '0';

-- result mantissa / exponent / sign
signal sum_exp: STD_LOGIC_VECTOR(8 downto 0):= (others => '0');
signal sum_mantissa: STD_LOGIC_VECTOR(24 downto 0):= (others => '0');
signal sum_sgn: STD_LOGIC := '0';

-- special cases signals
signal A_edge, B_edge, sum_edge: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal edge_case_true: STD_LOGIC := '0';

-- mantissa alligner signals
signal A_allign, B_allign: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal sum_exp_alligner: STD_LOGIC_VECTOR(8 downto 0);
signal sum_sgn_alligner: STD_LOGIC;
signal A_mantissa_out_alligner, B_mantissa_out_alligner: STD_LOGIC_VECTOR(24 downto 0);
signal sum_mantissa_alligner: STD_LOGIC_VECTOR(24 downto 0);  
signal nr_insignif_alligner: STD_LOGIC;

-- matissa calculator signals
signal A_mantissa_calc: STD_LOGIC_VECTOR(24 downto 0);
signal B_mantissa_calc: STD_LOGIC_VECTOR(24 downto 0);
signal A_sgn_calc: STD_LOGIC;
signal B_sgn_calc: STD_LOGIC;
signal sum_mantissa_out_calc: STD_LOGIC_VECTOR(24 downto 0);
signal sum_sgn_out_calc: STD_LOGIC;

-- mantissa normalizer signals
signal sum_mantissa_in_norm: STD_LOGIC_VECTOR(24 downto 0);
signal sum_exp_in_norm: STD_LOGIC_VECTOR(8 downto 0);
signal sum_mantissa_out_norm: STD_LOGIC_VECTOR(24 downto 0);
signal sum_exp_out_norm: STD_LOGIC_VECTOR(8 downto 0);

begin
-- resolve special cases
EDGECASE: EdgeCaseResolverAdder
PORT MAP ( A => A_edge,
B => B_edge,
sum => sum_edge,
edge_true => edge_case_true);

-- alliner
ALLIGN: AllignerAdder
PORT MAP ( A => A_allign, 
B => B_allign,
sum_exp => sum_exp_alligner,
sum_sgn => sum_sgn_alligner,
A_mantissa_out => A_mantissa_out_alligner,
B_mantissa_out => B_mantissa_out_alligner,
sum_mantissa => sum_mantissa_alligner,
nr_insignif => nr_insignif_alligner);

-- mantissa calculator
MANTISSACALC: MantissaCalculatorAdder
PORT MAP ( A_mantissa => A_mantissa_calc,
B_mantissa => B_mantissa_calc,
A_sgn => A_sgn_calc,
B_sgn => B_sgn_calc,
sum_mantissa => sum_mantissa_out_calc,
sum_sgn => sum_sgn_out_calc);

MANRISSANORM: MantissaNormalizerAdder
PORT MAP ( sum_mantissa_in => sum_mantissa_in_norm,
sum_exp_in => sum_exp_in_norm,
sum_mantissa_out => sum_mantissa_out_norm, 
sum_exp_out => sum_exp_out_norm);

-- fsm process
process(clk, reset)
    variable diff : signed(8 downto 0);
begin
	-- check reset signal
	if reset = '1' then
		state <= WAIT_STATE;
		done <= '0';
		sum <= (others => '0');
	-- when rising edge
	elsif rising_edge(clk) then
      	done <= '0';
		-- state cases
		case state is       	
			-- idle state, when start is '1', decode the inputs
			when WAIT_STATE =>
				-- check start signal
				if start = '1' then           	
					
					-- separate input
					A_sgn <= A(31);
            		A_exp <= "0" & A(30 downto 23);
           	 		A_mantissa <= "01" & A(22 downto 0);
            		B_sgn <= B(31);
            		B_exp <= "0" & B(30 downto 23);
            		B_mantissa <= "01" & B(22 downto 0);
					
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
					-- prepare allign
					A_allign <= A;
					B_allign <= B;
					state <= ALLIGN_STATE;	  
			   	end if;
			
			-- alling the mantissas
        	when ALLIGN_STATE =>    	
				sum_exp <= sum_exp_alligner;
				-- if one number is insignificant ignore it's mantissa
				if nr_insignif_alligner	= '1' then
					sum_mantissa <= sum_mantissa_alligner;
					sum_sgn <= sum_sgn_alligner;
					state <= OUTPUT_STATE;
				-- if it's needed, shift mantissas
				else
					A_mantissa <= A_mantissa_out_alligner; 
					B_mantissa <= B_mantissa_out_alligner;
					
					--prepare mantissas addition
					A_mantissa_calc <= A_mantissa_out_alligner;
					B_mantissa_calc <= B_mantissa_out_alligner;
					A_sgn_calc <= A_sgn;
					B_sgn_calc <= B_sgn; 
					
					state <= ADDITION_STATE;
				end if;
			
			-- add / subtract mantissas and select sign	
        	when ADDITION_STATE =>
				sum_mantissa <= sum_mantissa_out_calc;
            	sum_sgn <= sum_sgn_out_calc;
          		
				-- prepare mantissa and exp for normalization
				sum_mantissa_in_norm <=	sum_mantissa_out_calc;
				sum_exp_in_norm	<= sum_exp;
				
          		state <= NORMALIZE_STATE;
			
			-- normalize mantissa and exp	  
        	when NORMALIZE_STATE =>
				sum_mantissa <= sum_mantissa_out_norm;
            	sum_exp <= sum_exp_out_norm;
				state <= OUTPUT_STATE;			
			
			-- return early when invalid state found
        	when DETECTED_INVALID_STATE =>
          		sum <= sum_edge;
          		done <= '1';
          		if start = '0' then
            		done <= '0';
            		state <= WAIT_STATE;
          		end if;
		   	
			-- normal output state
			when OUTPUT_STATE =>
          		sum(31) <= sum_sgn;
          		sum(30 downto 23) <= sum_exp(7 downto 0);
          		sum(22 downto 0) <= sum_mantissa(22 downto 0);
          		done <= '1';
          		if start = '0' then
            		state <= WAIT_STATE;
          		end if;	  
				  
        	when others =>
          		state <= WAIT_STATE;
      	end case;
	end if;
end process;

end FloatingPointAdder_Architecture;
