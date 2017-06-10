library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Memory (Single unit for both instructions & data)
entity Memory is
port(WriteData         : in  std_logic_vector(31 downto 0);
     Address           : in  std_logic_vector(31 downto 0);
     MemRead, MemWrite : in  std_logic;
     ReadData          : out std_logic_vector(31 downto 0));
end Memory;

architecture beh of Memory is
-- Create Memory Structure
type memoryArray is array(0 to 2**8-1) of std_logic_vector(7 downto 0);
-- Memory Array Signals
signal instructionArray : memoryArray;
signal dataArray : memoryArray;
signal memArray : memoryArray;
begin

process(WriteData, Address, MemRead, MemWrite)
-- Integer & Boolean Declarations
variable i,j,r : integer;
variable flag : boolean := FALSE;
variable trigger1 : boolean := FALSE;
variable writeNow : boolean := FALSE;
begin
    
    -- Instruction memory
    -- lw $s0, 40($t0)
    memArray(0) <= "10001101";
    memArray(1) <= "00010000";
    memArray(2) <= "00000000";
    memArray(3) <= "00101000";
    -- lw $s1, 44($t0)
    memArray(4) <= "10001100";
    memArray(5) <= "00010001";
    memArray(6) <= "00000000";
    memArray(7) <= "00101100";
    -- beq $s0, $s1, L
    -- L is relative to how far the L code is from the NEXT line down.
    -- In this case, L is 2 lines from the next line down, being the 
    -- "sub" line, so L=00000010
    memArray(8) <= "00010010";
    memArray(9) <= "00010001";
    memArray(10) <= "00000000";
    memArray(11) <= "00000010";
    -- add $s3, $s4, $s5
    memArray(12) <= "00000010";
    memArray(13) <= "10010101";
    memArray(14) <= "10011000";
    memArray(15) <= "00100000";
    -- j exit
    -- 6 lines from begin line, hence 00000110 in last mem contents spot
    memArray(16) <= "00001000";
    memArray(17) <= "00000000";
    memArray(18) <= "00000000";
    memArray(19) <= "00000110";
    -- L: sub $s3, $s4, $s5
    memArray(20) <= "00000010";
    memArray(21) <= "10010101";
    memArray(22) <= "10011000";
    memArray(23) <= "00100010";
    -- exit: sw $s3, 48($t0)
    memArray(24) <= "10101101";
    memArray(25) <= "00010011";
    memArray(26) <= "00000000";
    memArray(27) <= "00110000";
    
    -- Initialize data memory
	if flag = FALSE then
	--memArray(40) <= "00000000";
	--memArray(41) <= "00000000";
	--memArray(42) <= "00000000";
	--memArray(43) <= "00000100"; -- positive 4
	--memArray(44) <= "00000000";
	--memArray(45) <= "00000000";
	--memArray(46) <= "00000000";
	--memArray(47) <= "00000100"; -- positive 4
    
        memArray(40) <= "11111111";
	memArray(41) <= "11111111";
	memArray(42) <= "11111111";
	memArray(43) <= "11111100"; -- negative 4
	memArray(44) <= "11111111";
	memArray(45) <= "11111111";
	memArray(46) <= "11111111";
	memArray(47) <= "11111011"; -- negative 5
	
    -- Set Flag
	flag := TRUE;
	end if;
    
    if MemRead='1' and Address/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then 
		r := conv_integer(unsigned(Address));
		ReadData <= memArray(r) & memArray(r+1) & memArray(r+2) & memArray(r+3);
    elsif MemWrite='1' and Address/="UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU" then
        r:=conv_integer(unsigned(Address));
		memArray(r) <= WriteData(31 downto 24);
		memArray(r+1) <= WriteData(23 downto 16);
		memArray(r+2) <= WriteData(15 downto 8);
		memArray(r+3) <= WriteData(7 downto 0);
    end if;
    
end process;

end beh;