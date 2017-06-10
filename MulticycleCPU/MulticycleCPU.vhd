----------------------------------------------------------------------------------
-- Drexel University: ECEC 412-001 - Modern Processor Design
-- Group 8: Bienvenido Bueno, Michael Cuskley, Gary Grossi, Joseph Haggerty
-- Description: VHDL implementation of a multicycle CPU. 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MulticycleCPU is
port(clk                : in  std_logic;
	 --CarryOut, 
     Overflow : out std_logic);
end MulticycleCPU;

architecture struc of MulticycleCPU is

component ALU is
generic(n : natural:=32);
port(a, b           : in  std_logic_vector(n-1 downto 0);
	 Oper           : in  std_logic_vector(3 downto 0);
	 Result         : buffer std_logic_vector(n-1 downto 0);
	 Zero, Overflow : buffer std_logic);
end component;

component ALUControl is
port(ALUOp:in std_logic_vector(1 downto 0);
     Funct:in std_logic_vector(5 downto 0);
     Operation:out std_logic_vector(3 downto 0));
end component;

component ALUOut is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end component;

component AND2 is
port(x, y : in  std_logic;
     z    : out std_logic);
end component;

component IR is
port(x            : in  std_logic_vector(31 downto 0);
     clk, IRWrite : in  std_logic;
     y            : out std_logic_vector(31 downto 0));
end component;

component MDR is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end component;

component Memory is
port(WriteData         : in  std_logic_vector(31 downto 0);
     Address           : in  std_logic_vector(31 downto 0);
     MemRead, MemWrite : in  std_logic;
     ReadData          : out std_logic_vector(31 downto 0));
end component;

component MulticycleControl is
port(Opcode : in std_logic_vector(5 downto 0);
     clk    : in std_logic;
     RegDst,RegWrite,ALUSrcA,IRWrite,MemtoReg,MemWrite,MemRead,IorD,PCWrite,PCWriteCond:out std_logic;
     ALUSrcB,ALUOp,PCSource : out std_logic_vector(1 downto 0));
end component;

component MUX5 is
port (sel : in  std_logic;
	 x, y : in  std_logic_vector(4 downto 0);
        z : out std_logic_vector(4 downto 0));
end component;

component MUX32 is
port (sel : in  std_logic;
	 x, y : in  std_logic_vector(31 downto 0);
        z : out std_logic_vector(31 downto 0));
end component;

component MUX3Way is
port(w, x, y : in  std_logic_vector(31 downto 0);
     sel     : in  std_logic_vector(1 downto 0);
     z       : out std_logic_vector(31 downto 0));
end component;

component MUX4Way is
port(v, w, x, y : in  std_logic_vector(31 downto 0);
     sel        : in  std_logic_vector(1 downto 0);
     z          : out std_logic_vector(31 downto 0));
end component;

component NOR32 is
    port(x:in std_logic_vector(31 downto 0);y:out std_logic);
end component;

component OR2 is
port(x, y : in  std_logic;
        z : out std_logic);
end component;

component PCMulticycle is
port(clk, d     : in  std_logic;
     AddressIn  : in  std_logic_vector(31 downto 0);
     AddressOut : out std_logic_vector(31 downto 0));
end component;

component RegA is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end component;

component RegB is
port(x   : in  std_logic_vector(31 downto 0);
     clk : in  std_logic;
     y   : out std_logic_vector(31 downto 0));
end component;

component registers is
port(RR1, RR2, WR : in  std_logic_vector(4 downto 0);
     WD           : in  std_logic_vector(31 downto 0);
     RegWrite     : in  std_logic;
     RD1,RD2      : out std_logic_vector(31 downto 0));
end component;

component ShiftLeft2 is
generic(n:natural:=32; k:natural:=2);
port(x : in  std_logic_vector(n-1 downto 0);
     y : out std_logic_vector(n-1 downto 0));
end component;

component ShiftLeft2Jump is
port( x : in  std_logic_vector(25 downto 0);
      y : in  std_logic_vector(3 downto 0);
      z : out std_logic_vector(31 downto 0));
end component;

component SignExtend is
generic(n:natural:=16);
port(x : in  std_logic_vector(n-1 downto 0);
	 y : out std_logic_vector(2*n-1 downto 0));
end component;

-- Signals
signal C,E,F,G,H,I,J,L,M,N,P,Q,R,S,T,U,V : std_logic_vector(31 downto 0);
signal D,W : std_logic;
signal K : std_logic_vector(4 downto 0);

signal Instruction : std_logic_vector(31 downto 0);
signal Operation:STD_LOGIC_VECTOR(3 downto 0);
signal RegDst,RegWrite,ALUSrcA,PCWriteCond,PCWrite,IorD,MemRead,MemWrite,MemtoReg,IRWrite,Zero : std_logic;
signal PCSource, ALUOp, ALUSrcB : std_logic_vector(1 downto 0);
signal four:STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000100";

begin

-- Connecting components together
PC_0:  PCMulticycle port map(clk,D,C,E);
Address_MUX:  MUX32 port map(IorD,E,F,G);
Mem_0:  Memory port map(H,G,MemRead,MemWrite,I);
InstrReg:  IR port map(I,clk,IRWrite,Instruction);
MemDataReg:  MDR port map(I,clk,J);
Control:  MulticycleControl port map(I(31 downto 26),clk,RegDst,RegWrite,ALUSrcA,IRWrite,MemtoReg,MemWrite,MemRead,IorD,PCWrite,PCWriteCond,ALUSrcB,ALUOp,PCSource);
WriteRegMUX:  MUX5 port map(RegDst,Instruction(20 downto 16),Instruction(15 downto 11),K);
WriteDataMUX:  MUX32 port map(MemtoReg,F,J,L);
Reg:  registers port map(Instruction(25 downto 21),Instruction(20 downto 16),K,L,RegWrite,M,N);
SignEx: SignExtend port map(Instruction(15 downto 0),Q);
ShftL: ShiftLeft2 port map(Q,R);
RegA_0: RegA port map(M,clk,P);
RegB_0: RegB port map(N,clk,H);
aMUX: MUX32 port map(ALUSrcA,E,P,S);
bMUX: MUX4Way port map(H,four,Q,R,ALUSrcB,T);
ALUCtrl: ALUControl port map(ALUOp,Instruction(5 downto 0),Operation);
ShftL2J: ShiftLeft2Jump port map(Instruction(25 downto 0),E(31 downto 28),V);
ALU_0: ALU port map(S,T,Operation,U,Zero,Overflow);
finalMUX: MUX3Way port map(U,F,V,PCSource,C);
ALUReg: ALUOut port map(U,clk,F);
AND_0: AND2 port map(Zero,PCWriteCond,W);
OR_0: OR2 port map(W,PCWrite,D);

end struc;