library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CarryLookaheadAdder9b is
Port ( x: in STD_LOGIC_VECTOR (8 downto 0);
       y: in STD_LOGIC_VECTOR (8 downto 0);
	   cin: in STD_LOGIC;
       cout: out STD_LOGIC;
       s: out STD_LOGIC_VECTOR (8 downto 0));
end entity;

architecture CarryLookaheadAdder9b_Architecture of CarryLookaheadAdder9b is

component FullAdder is
Port ( x: in STD_LOGIC;
       y: in STD_LOGIC;
       cin: in STD_LOGIC;
       cout: out STD_LOGIC;
       s: out STD_LOGIC);
end component;

signal g: std_logic_vector(8 downto 0);
signal p: std_logic_vector(8 downto 0);
signal carry: std_logic_vector(8 downto 0);
signal carryOut: std_logic_vector(8 downto 0);

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

carry(0) <= g(0) or (p(0) and cin);
carry(1) <= g(1) or (p(1) and carry(0));
carry(2) <= g(2) or (p(2) and carry(1));
carry(3) <= g(3) or (p(3) and carry(2));
carry(4) <= g(4) or (p(4) and carry(3));
carry(5) <= g(5) or (p(5) and carry(4));
carry(6) <= g(6) or (p(6) and carry(5));
carry(7) <= g(7) or (p(7) and carry(6));
carry(8) <= g(8) or (p(8) and carry(7));

cout <= carry(8);

Add1: FullAdder port map (x(0), y(0), cin, carryOut(0), s(0));
Add2: FullAdder port map (x(1), y(1), carry(0), carryOut(1), s(1));
Add3: FullAdder port map (x(2), y(2), carry(1), carryOut(2), s(2));
Add4: FullAdder port map (x(3), y(3), carry(2), carryOut(3), s(3));
Add5: FullAdder port map (x(4), y(4), carry(3), carryOut(4), s(4));
Add6: FullAdder port map (x(5), y(5), carry(4), carryOut(5), s(5));
Add7: FullAdder port map (x(6), y(6), carry(5), carryOut(6), s(6));
Add8: FullAdder port map (x(7), y(7), carry(6), carryOut(7), s(7));
Add9: FullAdder port map (x(8), y(8), carry(7), carryOut(8), s(8));

end CarryLookaheadAdder9b_Architecture;
