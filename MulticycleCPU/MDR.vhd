library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Memory Data Register
entity MDR is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end MDR;

architecture beh of MDR is
signal count : integer := 0;
begin

process(clk, x)
begin

-- Initialization
if count = 0 then
    y <= (others => '0');
    count <= count + 1;
end if;

-- Update on each clock cycle
if clk='1' and clk'event then
    y <= x;
end if;

end process;

end beh;