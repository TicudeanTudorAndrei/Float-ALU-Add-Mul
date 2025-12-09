library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TwosComplement25b is
Port ( x: in STD_LOGIC_VECTOR (24 downto 0);
x_2comp: out STD_LOGIC_VECTOR (24 downto 0));
end entity;

architecture TwosComplement25b_Architecture of TwosComplement25b is

component CarryLookaheadAdder25b is
Port ( x : in STD_LOGIC_VECTOR (24 downto 0);
y : in STD_LOGIC_VECTOR (24 downto 0);
cin : in STD_LOGIC;
cout : out STD_LOGIC;
s : out STD_LOGIC_VECTOR (24 downto 0));
end component;

signal inverted_x : STD_LOGIC_VECTOR (24 downto 0) := (others => '0');
signal cout: STD_LOGIC := '0';

begin

inverted_x <= NOT x;

adder : CarryLookaheadAdder25b 
port map ( x => inverted_x,
y => "0000000000000000000000001",
cin => '0',
cout => cout,
s => x_2comp);



end TwosComplement25b_Architecture;