library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CarryLookaheadAdder24b is
Port ( a: in STD_LOGIC_VECTOR (23 downto 0);
b: in STD_LOGIC_VECTOR (23 downto 0);
r: out STD_LOGIC_VECTOR (24 downto 0));
end entity;

architecture CarryLookaheadAdder24b_Architecture of carryLookaheadAdder24b is

component FullAdder is
Port ( x: in STD_LOGIC;
y: in STD_LOGIC;
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC);
end component;

signal g: STD_LOGIC_VECTOR(23 downto 0);
signal p: STD_LOGIC_VECTOR(23 downto 0);
signal carry: STD_LOGIC_VECTOR(23 downto 0);

begin

g <= a and b;
p <= a or b;

carry(0) <= g(0) or (p(0) and '0');
carry(1) <= g(1) or (p(1) and carry(0));
carry(2) <= g(2) or (p(2) and carry(1));
carry(3) <= g(3) or (p(3) and carry(2));
carry(4) <= g(4) or (p(4) and carry(3));
carry(5) <= g(5) or (p(5) and carry(4));
carry(6) <= g(6) or (p(6) and carry(5));
carry(7) <= g(7) or (p(7) and carry(6));
carry(8) <= g(8) or (p(8) and carry(7));
carry(9) <= g(9) or (p(9) and carry(8));
carry(10) <= g(10) or (p(10) and carry(9));
carry(11) <= g(11) or (p(11) and carry(10));
carry(12) <= g(12) or (p(12) and carry(11));
carry(13) <= g(13) or (p(13) and carry(12));
carry(14) <= g(14) or (p(14) and carry(13));
carry(15) <= g(15) or (p(15) and carry(14));
carry(16) <= g(16) or (p(16) and carry(15));
carry(17) <= g(17) or (p(17) and carry(16));
carry(18) <= g(18) or (p(18) and carry(17));
carry(19) <= g(19) or (p(19) and carry(18));
carry(20) <= g(20) or (p(20) and carry(19));
carry(21) <= g(21) or (p(21) and carry(20));
carry(22) <= g(22) or (p(22) and carry(21));
carry(23) <= g(23) or (p(23) and carry(22));
r(24) <= carry(23);

FA0: FullAdder port map (a(0), b(0), '0', open, r(0));
FA1: FullAdder port map (a(1), b(1), carry(0), open, r(1));
FA2: FullAdder port map (a(2), b(2), carry(1), open, r(2));
FA3: FullAdder port map (a(3), b(3), carry(2), open, r(3));
FA4: FullAdder port map (a(4), b(4), carry(3), open, r(4));
FA5: FullAdder port map (a(5), b(5), carry(4), open, r(5));
FA6: FullAdder port map (a(6), b(6), carry(5), open, r(6));
FA7: FullAdder port map (a(7), b(7), carry(6), open, r(7));
FA8: FullAdder port map (a(8), b(8), carry(7), open, r(8));
FA9: FullAdder port map (a(9), b(9), carry(8), open, r(9));
FA10: FullAdder port map (a(10), b(10), carry(9), open, r(10));
FA11: FullAdder port map (a(11), b(11), carry(10), open, r(11));
FA12: FullAdder port map (a(12), b(12), carry(11), open, r(12));
FA13: FullAdder port map (a(13), b(13), carry(12), open, r(13));
FA14: FullAdder port map (a(14), b(14), carry(13), open, r(14));
FA15: FullAdder port map (a(15), b(15), carry(14), open, r(15));
FA16: FullAdder port map (a(16), b(16), carry(15), open, r(16));
FA17: FullAdder port map (a(17), b(17), carry(16), open, r(17));
FA18: FullAdder port map (a(18), b(18), carry(17), open, r(18));
FA19: FullAdder port map (a(19), b(19), carry(18), open, r(19));
FA20: FullAdder port map (a(20), b(20), carry(19), open, r(20));
FA21: FullAdder port map (a(21), b(21), carry(20), open, r(21));
FA22: FullAdder port map (a(22), b(22), carry(21), open, r(22));
FA23: FullAdder port map (a(23), b(23), carry(22), open, r(23));

end CarryLookaheadAdder24b_Architecture;
