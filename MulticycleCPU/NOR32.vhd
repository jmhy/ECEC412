library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NOR32 is
    port(x:in std_logic_vector(31 downto 0);y:out std_logic);
end NOR32;

architecture Behavioral of NOR32 is
begin
process(x)
    variable temp: std_logic;
    begin
        if x="00000000000000000000000000000000" then
            temp := '1';
        else
            temp := '0';
        end if;            
        
        y <= temp;    

end process;

end Behavioral;

