library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUOut is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end ALUOut;

architecture beh of ALUOut is
begin

process(clk)
begin

if clk='1' and clk'event then
    y <= x;
end if;

end process;

end beh;