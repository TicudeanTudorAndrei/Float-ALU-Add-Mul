library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all; 

entity ShifterAdder is
Port ( mantissa_in : in STD_LOGIC_VECTOR(24 downto 0);
shift_amount : in STD_LOGIC_VECTOR(8 downto 0);
mantissa_out : out STD_LOGIC_VECTOR(24 downto 0));
end entity;

architecture ShifterAdder_Architecture of ShifterAdder is
begin
	process(mantissa_in, shift_amount)
		begin
			mantissa_out <= std_logic_vector(shift_right(unsigned(mantissa_in), to_integer(unsigned(shift_amount))));
	end process;
end ShifterAdder_Architecture;
