library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SignExtend is
generic(n:natural:=16);
port(x : in  std_logic_vector(n-1 downto 0);
     y : out std_logic_vector(2*n-1 downto 0));
end SignExtend;

architecture Behavioral of SignExtend is
begin

y <= std_logic_vector(resize(signed(x), y'length));

end Behavioral;