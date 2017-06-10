library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity PCMulticycle is
port(clk, d     : in  std_logic;
     AddressIn  : in  std_logic_vector(31 downto 0);
     AddressOut : out std_logic_vector(31 downto 0));
end PCMulticycle;

architecture beh of PCMulticycle is
signal count : integer := 0;
begin

process(clk, d, AddressIn)
begin

-- Initialization
if count = 0 then
    AddressOut <= (others => '0');
    count <= count + 1;
end if;

-- Update on clock cycle when current instruction finishes executing
if clk='1' and clk'event and d = '1' then
    AddressOut <= AddressIn;
end if;

end process;

end beh;