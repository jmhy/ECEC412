library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity ShiftLeft2Jump is
port( x : in  std_logic_vector(25 downto 0);
      y : in  std_logic_vector(3 downto 0);
      z : out std_logic_vector(31 downto 0));
end ShiftLeft2Jump;

architecture beh of ShiftLeft2Jump is
signal temp : std_logic_vector(31 downto 0);
begin

process(x,y)
begin

temp(31 downto 28) <= y;
temp(27 downto 2) <= x;
temp(1 downto 0) <= "00";

end process;

z <= temp;

end beh; 