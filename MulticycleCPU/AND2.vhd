library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity AND2 is
port(x, y : in  std_logic;
        z : out std_logic);
end AND2;

architecture Behavioral of AND2 is
begin

process(x,y)
variable temp: std_logic;
begin
    if (x=y) then
        temp := x;
    else
        temp := '0';
    end if;            
    
    z <= temp;    

end process;

end Behavioral;
