library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity TopLevelModule is
port ( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
clk: in STD_LOGIC;
reset: in STD_LOGIC;
start_sum: in STD_LOGIC;
start_mul: in STD_LOGIC;
done_sum: out STD_LOGIC;
done_mul: out STD_LOGIC;
sum: out STD_LOGIC_VECTOR(31 downto 0);
product: out STD_LOGIC_VECTOR(31 downto 0));
end entity;

architecture TopLevelModule_Architecture of TopLevelModule is

component FloatingPointAdder is
port ( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
clk: in STD_LOGIC;
reset: in STD_LOGIC;
start: in STD_LOGIC;
done: out STD_LOGIC;
sum: out STD_LOGIC_VECTOR(31 downto 0));
end component;

component FloatingPointMultiplier is
port ( A: in STD_LOGIC_VECTOR(31 downto 0);
B: in STD_LOGIC_VECTOR(31 downto 0);
clk: in STD_LOGIC;
reset: in STD_LOGIC;
start: in STD_LOGIC;
done: out STD_LOGIC;
product: out STD_LOGIC_VECTOR(31 downto 0));
end component;

begin

AdderInst: FloatingPointAdder
port map ( A => A,
B => B,
clk => clk,
reset => reset,
start => start_sum,
done => done_sum,
sum => sum);

MultiplierInst: FloatingPointMultiplier
port map ( A => A,
B => B,
clk => clk,
reset => reset,
start => start_mul,
done => done_mul,
product  => product);

end architecture TopLevelModule_Architecture;
