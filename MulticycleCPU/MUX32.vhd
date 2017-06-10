library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX32 is
port (sel : in  std_logic;
	 x, y : in  std_logic_vector(31 downto 0);
        z : out std_logic_vector(31 downto 0));
end MUX32;

architecture beh of MUX32 is
begin

process(sel, x, y)
begin

if sel = '0' then
	z <= x;
else
	z <= y;
end if;

end process;

end beh;