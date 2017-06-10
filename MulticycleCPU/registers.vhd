library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_arith.ALL;

entity registers is
port(RR1, RR2, WR : in  std_logic_vector(4 downto 0);
     WD           : in  std_logic_vector(31 downto 0);
     RegWrite     : in  std_logic;
     RD1,RD2      : out std_logic_vector(31 downto 0));
end registers;

architecture beh of registers is
type twodarray is array(0 to 31) of std_logic_vector(31 downto 0);
signal regcontents:twodarray;
begin

process(RR1, RR2, WR, WD)
variable i,j,k:integer;
variable flag:boolean:=FALSE;
begin
    -- Initialize registers
	if flag=FALSE then
		regcontents(0)<=(others=>'0');
		regcontents(8)<="00000000000000000000000000000000";
		regcontents(20)<="00000000000000000000000000001110";
		regcontents(21)<="00000000000000000000000000000101";
		flag:=TRUE;
	end if;
    
    -- Updating registers
	i:=conv_integer(unsigned(RR1));
	j:=conv_integer(unsigned(RR2));
	k:=conv_integer(unsigned(WR));
	
	RD1<=regcontents(i);
	RD2<=regcontents(j);
    if RegWrite='1' and (k /= 0) then	
		regcontents(k) <= WD;
	end if;
    
end process;

end beh;