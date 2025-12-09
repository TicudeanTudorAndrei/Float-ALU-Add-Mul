library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CarryLookaheadAdder25b is
Port ( x: in STD_LOGIC_VECTOR (24 downto 0);
y: in STD_LOGIC_VECTOR (24 downto 0);
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC_VECTOR (24 downto 0));
end entity;

architecture CarryLookaheadAdder25b_Architecture of CarryLookaheadAdder25b is

component FullAdder is
Port ( x: in STD_LOGIC;
y: in STD_LOGIC;
cin: in STD_LOGIC;
cout: out STD_LOGIC;
s: out STD_LOGIC);
end component;

signal g: STD_LOGIC_VECTOR(24 downto 0);
signal p: STD_LOGIC_VECTOR(24 downto 0);
signal carry: STD_LOGIC_VECTOR(24 downto 0);

begin

g(0) <= x(0) and y(0);
p(0) <= x(0) or y(0);

g(1) <= x(1) and y(1);
p(1) <= x(1) or y(1);

g(2) <= x(2) and y(2);
p(2) <= x(2) or y(2);

g(3) <= x(3) and y(3);
p(3) <= x(3) or y(3);

g(4) <= x(4) and y(4);
p(4) <= x(4) or y(4);

g(5) <= x(5) and y(5);
p(5) <= x(5) or y(5);

g(6) <= x(6) and y(6);
p(6) <= x(6) or y(6);

g(7) <= x(7) and y(7);
p(7) <= x(7) or y(7);

g(8) <= x(8) and y(8);
p(8) <= x(8) or y(8);

g(9) <= x(9) and y(9);
p(9) <= x(9) or y(9);

g(10) <= x(10) and y(10);
p(10) <= x(10) or y(10);

g(11) <= x(11) and y(11);
p(11) <= x(11) or y(11);

g(12) <= x(12) and y(12);
p(12) <= x(12) or y(12);

g(13) <= x(13) and y(13);
p(13) <= x(13) or y(13);

g(14) <= x(14) and y(14);
p(14) <= x(14) or y(14);

g(15) <= x(15) and y(15);
p(15) <= x(15) or y(15);

g(16) <= x(16) and y(16);
p(16) <= x(16) or y(16);

g(17) <= x(17) and y(17);
p(17) <= x(17) or y(17);

g(18) <= x(18) and y(18);
p(18) <= x(18) or y(18);

g(19) <= x(19) and y(19);
p(19) <= x(19) or y(19);

g(20) <= x(20) and y(20);
p(20) <= x(20) or y(20);

g(21) <= x(21) and y(21);
p(21) <= x(21) or y(21);

g(22) <= x(22) and y(22);
p(22) <= x(22) or y(22);

g(23) <= x(23) and y(23);
p(23) <= x(23) or y(23);

g(24) <= x(24) and y(24);
p(24) <= x(24) or y(24);

carry(0) <= g(0) or (p(0) and cin);
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
carry(24) <= g(24) or (p(24) and carry(23));
cout <= carry(24);

FA0: FullAdder port map (x(0), y(0), cin, open, s(0));
FA1: FullAdder port map (x(1), y(1), carry(0), open, s(1));
FA2: FullAdder port map (x(2), y(2), carry(1), open, s(2));
FA3: FullAdder port map (x(3), y(3), carry(2), open, s(3));
FA4: FullAdder port map (x(4), y(4), carry(3), open, s(4));
FA5: FullAdder port map (x(5), y(5), carry(4), open, s(5));
FA6: FullAdder port map (x(6), y(6), carry(5), open, s(6));
FA7: FullAdder port map (x(7), y(7), carry(6), open, s(7));
FA8: FullAdder port map (x(8), y(8), carry(7), open, s(8));
FA9: FullAdder port map (x(9), y(9), carry(8), open, s(9));
FA10: FullAdder port map (x(10), y(10), carry(9), open, s(10));
FA11: FullAdder port map (x(11), y(11), carry(10), open, s(11));
FA12: FullAdder port map (x(12), y(12), carry(11), open, s(12));
FA13: FullAdder port map (x(13), y(13), carry(12), open, s(13));
FA14: FullAdder port map (x(14), y(14), carry(13), open, s(14));
FA15: FullAdder port map (x(15), y(15), carry(14), open, s(15));
FA16: FullAdder port map (x(16), y(16), carry(15), open, s(16));
FA17: FullAdder port map (x(17), y(17), carry(16), open, s(17));
FA18: FullAdder port map (x(18), y(18), carry(17), open, s(18));
FA19: FullAdder port map (x(19), y(19), carry(18), open, s(19));
FA20: FullAdder port map (x(20), y(20), carry(19), open, s(20));
FA21: FullAdder port map (x(21), y(21), carry(20), open, s(21));
FA22: FullAdder port map (x(22), y(22), carry(21), open, s(22));
FA23: FullAdder port map (x(23), y(23), carry(22), open, s(23));
FA24: FullAdder port map (x(24), y(24), carry(23), open, s(24));

end CarryLookaheadAdder25b_Architecture;
