library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity EdgeCaseResolverAdder is
port( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
sum: out STD_LOGIC_VECTOR(31 downto 0);
edge_true: out STD_LOGIC);
end entity;

architecture EdgeCaseResolverAdder_Architecture of EdgeCaseResolverAdder is

-- special cases: NaN / infinite / zero
signal A_is_nan, B_is_nan: STD_LOGIC := '0';
signal A_is_inf, B_is_inf: STD_LOGIC := '0';
signal A_is_zero, B_is_zero: STD_LOGIC := '0';

begin
 
A_is_nan <= '1' when (A(30 downto 23) = "11111111") and (A(22 downto 0) /= "00000000000000000000000") else '0';
B_is_nan <= '1' when (B(30 downto 23) = "11111111") and (B(22 downto 0) /= "00000000000000000000000") else '0';

A_is_inf <= '1' when (A(30 downto 23) = "11111111") and (A(22 downto 0) = "00000000000000000000000") else '0';
B_is_inf <= '1' when (B(30 downto 23) = "11111111") and (B(22 downto 0) = "00000000000000000000000") else '0';

A_is_zero <= '1' when A(30 downto 0) = "0000000000000000000000000000000" else '0';
B_is_zero <= '1' when B(30 downto 0) = "0000000000000000000000000000000" else '0';

sum <= A when A_is_nan = '1' else
	   B when B_is_nan = '1' else 
	   "01111111100000000000000000000000" when A_is_inf = '1' and B_is_inf = '1' and A(31) /= B(31) else
	   A when A_is_inf = '1' else
       B when B_is_inf = '1' else
       B when A_is_zero = '1' else
       A when B_is_zero = '1' else
       x"00000000";

edge_true <= '1' when A_is_nan = '1' or B_is_nan = '1' or A_is_inf = '1' or B_is_inf = '1' or A_is_zero = '1' or B_is_zero = '1' else
         	 '0';
			
end EdgeCaseResolverAdder_Architecture;
