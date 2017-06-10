library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MulticycleControl is
port(Opcode : in std_logic_vector(5 downto 0);
     clk    : in std_logic;
     RegDst,RegWrite,ALUSrcA,IRWrite,MemtoReg,MemWrite,MemRead,IorD,PCWrite,PCWriteCond:out std_logic;
     ALUSrcB,ALUOp,PCSource : out std_logic_vector(1 downto 0));
end MulticycleControl;

architecture beh of MulticycleControl is
begin

process(clk, Opcode)
type state is (zero,one,two,three,four,five,six,seven,eight,nine);
variable ns : state := zero;
variable temp:std_logic_vector(15 downto 0);
begin

if clk='1' and clk'event then
    case ns is
        when zero => 
	    temp := "UU01UU101U010000";
            ns := one;
        when one =>
            temp := "UU0UUUUUUU1100UU";
            if (Opcode="100011") or (Opcode="101011") then
                ns := two; -- LW or SW
            elsif Opcode="000000" then
                ns := six; -- R-Type
            elsif Opcode="000100" then
                ns := eight; -- BEQ
            elsif Opcode="000010" then
                ns := nine; -- Jump
            end if;
        when two =>
            temp := "UU1UUUUUUU1000UU";
            if Opcode="100011" then
                ns := three; -- LW
            elsif Opcode="101011" then
                ns := five; -- SW
            end if;
        when three =>
            temp := "UUUUUU11UUUUUUUU";
            ns := four;
        when four =>
            temp := "01UU1UUUUUUUUUUU";
            ns := zero;
        when five =>
            temp := "UUUUU1U1UUUUUUUU";
            ns := zero;
        when six =>
            temp := "UU1UUUUUUU0010UU";
            ns := seven;
        when seven =>
            temp := "11UU0UUUUUUUUUUU";
            ns := zero;
        when eight =>
            temp := "UU1UUUUUU1000101";
            ns := zero;
        when nine =>
            temp := "UUUUUUUU1UUUUU10";
            ns := zero;
        when others =>
            null;
    end case;

    RegDst <= temp(15);
    RegWrite <= temp(14);
    ALUSrcA <= temp(13);
    IRWrite <= temp(12);
    MemtoReg <= temp(11);
    MemWrite <= temp(10);
    MemRead <= temp(9);
    IorD <= temp(8);
    PCWrite <= temp(7);
    PCWriteCond <= temp(6);
    ALUSrcB <= temp(5 downto 4);
    ALUOp <= temp(3 downto 2);
    PCSource <= temp(1 downto 0);

end if;

end process;

end beh;