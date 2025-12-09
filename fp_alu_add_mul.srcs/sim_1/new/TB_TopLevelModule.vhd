library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_TopLevelModule is
end TB_TopLevelModule;

architecture TB_TopLevelModule_Architecture of TB_TopLevelModule is

component TopLevelModule is
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
end component;

signal A, B: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
signal clk: STD_LOGIC := '0';
signal reset: STD_LOGIC := '0';
signal start_sum, start_mul: STD_LOGIC := '0';
signal done_sum, done_mul: STD_LOGIC := '0';
signal sum, product: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');

constant clk_period : time := 10 ns;

begin

tested: TopLevelModule
port map ( A => A,
B => B,
clk => clk,
reset => reset,
start_sum => start_sum,
start_mul => start_mul,
done_sum => done_sum,
done_mul => done_mul,
sum => sum,
product => product);

clk_process : process
begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
end process;

process
begin

reset <= '1';
wait for 20 ns;
reset <= '0';
wait for 20 ns;
----------------------------------------------------------------------------------------------------       
A <= X"40D40000"; B <= X"40C80000";  -- 6.625 * 6.25 = 41.40625, 6.625 + 6.25 = 12.875
start_sum <= '1'; 
start_mul <= '1';

wait for 10 ns;

start_sum <= '0'; 
start_mul <= '0';
        
wait until done_mul = '1';
wait until done_sum = '1';
-- explected: sum = X"414e0000" and product = X"4225a000"
wait for 50 ns;
----------------------------------------------------------------------------------------------------   
A <= X"40A30000"; B <= X"40F00000";  -- 5.09375 * 7.5 = 38.203125, 5.09375 + 7.5 = 12.59375
start_sum <= '1';
start_mul <= '1';

wait for 10 ns;
        
start_sum <= '0'; 
start_mul <= '0';
        
wait until done_mul = '1';
wait until done_sum = '1';
-- expected: sum = X"41498000" and product = X"4218d000"
wait for 50 ns;
----------------------------------------------------------------------------------------------------   
wait;
end process;

end TB_TopLevelModule_Architecture;