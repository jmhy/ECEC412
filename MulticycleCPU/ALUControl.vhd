library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALUControl is
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end ALUControl;


architecture Behavioral of ALUControl is
begin
process(ALUOp,Funct)
variable temp:std_logic_vector(3 downto 0);
begin
temp := Funct(3 downto 0);

if ALUOp="00" then
	Operation<="0010";
elsif ALUOp="01" then
	Operation<="0110";
elsif ALUOp="10" then
	case temp is
		when "0000"=>
			Operation<="0010";
		when "0010"=>
			Operation<="0110";
		when "0100"=>
			Operation<="0000";
		when "0101"=>
			Operation<="0001";
        when "1010"=>
			Operation<="0111";
		when others=>
			Operation<="UUUU";
	end case;
end if;

end process;

end Behavioral;
