library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Instruction Register (IR)
entity IR is
port(x            : in  std_logic_vector(31 downto 0);
     clk, IRWrite : in  std_logic;
     y            : out std_logic_vector(31 downto 0));
end IR;

architecture beh of IR is
signal count : integer := 0;
begin

process (clk, IRWrite, x)
begin

-- Initialization
if count = 0 then
    y <= (others => '0');
    count <= count + 1;
end if;

-- Only update instruction when needed
if clk='1' and clk'event then
    if IRWrite='1' then
        y <= x;
    end if;
end if;

end process;

end beh;