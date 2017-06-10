library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ShiftLeft2 is
generic(n:natural:=32; k:natural:=2);
port(x : in  std_logic_vector(n-1 downto 0);
     y : out std_logic_vector(n-1 downto 0));
end ShiftLeft2;

architecture Behavioral of ShiftLeft2 is
begin

y <= std_logic_vector(shift_left(signed(x),k));

end Behavioral;