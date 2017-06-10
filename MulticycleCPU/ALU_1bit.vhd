library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ALU_1bit is
port(a,b,less,CarryIn: in std_logic; Ainvert, Binvert, Op1, Op0: in std_logic;
    Result, CarryOut, set: out std_logic);
end ALU_1bit;

architecture Behavioral of ALU_1bit is
begin
process(a,b,less,CarryIn,Ainvert,Binvert,Op1,Op0)
variable control : std_logic_vector(3 downto 0);
begin
    control := Ainvert & Binvert & Op1 & Op0;
    case control is
        when "0000"=>
            -- and operation
            Result <= a and b;
        when "0001"=>
            -- or operation
            Result <= a or b;
        when "0010"=>
            -- add operation
            Result <= a xor b xor CarryIn;
            CarryOut <=  (a and b) or (a and CarryIn) or (b and CarryIn);
        when "0110"=>
            -- subtract operation
            Result <= a xor (not b) xor CarryIn;
            CarryOut <= (a and not b) or (a and CarryIn) or (not b and CarryIn);
        when "0111"=>
            -- slt operation
            set<=a xor (not b) xor CarryIn;
            CarryOut <= (a and not b) or (a and CarryIn) or (not b and CarryIn);
            Result <= less;
        when "1100"=>
            -- nor operation
            Result<=(not a) and (not b);
        when others=>
            Result <= 'U';
            CarryOut <= 'U';
        end case;
end process;

end Behavioral;
