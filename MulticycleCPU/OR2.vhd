library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity OR2 is
port(x, y : in  std_logic;
        z : out std_logic);
end OR2;

architecture Behavioral of OR2 is
begin
process(x,y)
variable temp: std_logic;
begin
    if x='1' or y='1' then
        temp := '1';
    else
        temp := '0';
    end if;            
    z <= temp;    

end process;

end Behavioral;
