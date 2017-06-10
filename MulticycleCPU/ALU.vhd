library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity ALU is
generic(n : natural:=32);
port(a, b           : in  std_logic_vector(n-1 downto 0);
	 Oper           : in  std_logic_vector(3 downto 0);
	 Result         : buffer std_logic_vector(n-1 downto 0);
	 Zero, Overflow : buffer std_logic);
end ALU;

architecture struc of ALU is

component ALU_1bit is
port(a, b, less, CarryIn        : in  std_logic;
     Ainvert, Binvert, Op1, Op0 : in  std_logic;
     Result, CarryOut, set      : out std_logic);
end component;

component NOR32 is
port(x : in  std_logic_vector(31 downto 0);
     y : out std_logic);
end component;

signal rip_carry : STD_LOGIC_VECTOR(n-1 downto 0);
signal set31, set31_to_less0 : STD_LOGIC;

begin

-- Generates here
	G1: for i in 0 to n-1 generate
		-- 1 bit ALU # 1
		G2: if i=0 generate
			ALU0: ALU_1bit port map(a(i),b(i),set31_to_less0,oper(2),oper(3),oper(2),oper(1),oper(0),Result(i),rip_carry(i),open);
		end generate G2;
		-- 1 bit ALU's #2-31
		G3: if i>0 and i<n-1 generate
			ALU1: ALU_1bit port map(a(i),b(i),'0',rip_carry(i-1),oper(3),oper(2),oper(1),oper(0),Result(i),rip_carry(i),open);
		end generate G3;
		-- 1 bit ALU #32
		G4: if i=n-1 generate
			ALU2: ALU_1bit port map(a(i),b(i),'0',rip_carry(i-1),oper(3),oper(2),oper(1),oper(0),Result(i),rip_carry(i),set31);
		end generate G4;
		
	end generate G1;
	
	-- Logic for overflow and determining set signal that is sent back to first ALU
	N1: NOR32 port map(Result,Zero); 
	
	Overflow <= rip_carry(n-2) xor rip_carry(n-1);
	set31_to_less0 <= set31 xor Overflow;

end struc;
