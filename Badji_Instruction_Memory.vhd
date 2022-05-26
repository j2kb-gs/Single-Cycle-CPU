library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all;  

ENTITY Badji_Instruction_Memory IS 
PORT (
    --BADJI_CLOCK: IN STD_LOGIC; 
    Badji_PC : IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
    Badji_Instr : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

    );
END Badji_Instruction_Memory; 

ARCHITECTURE instr_mem OF Badji_Instruction_Memory IS 

SIGNAL BADJI_INSTR_ADDR : STD_LOGIC_VECTOR (4 DOWNTO 0); 


TYPE BADJI_ROM_TYPE IS ARRAY (0 TO 31) OF  STD_LOGIC_VECTOR (31 DOWNTO 0); 
-- Mips instruction being executed
-- and $s0, $s0, $zero
-- addi $s1, $s1, 5
-- and $a0, $a0, $zero
-- and $t0, $t0, $zero
-- and $t1, $t1, $zero
-- loop: 
-- beq $s0, $s1, exit
-- lw $t0, array1($a0)
-- add $t1, $t1, $t0
-- addi $a0, $a0, 4
-- addi $s0, $s0, 1
-- j loop
CONSTANT BADJI_ROM_DATA: BADJI_ROM_TYPE:= 
    (     
        X"02008024", X"22310005", X"00802024", X"01004024", -- 0X00 -- 0x00
        X"01204824", X"12110007", X"3c011001", X"00240821", -- 0X04 -- 0x10
        X"8c280000", X"01284820", X"20840004", X"22100001", -- 0X08 -- 0x20
        X"08100005", X"00000000", X"00000000", X"00000000", -- 0X0C -- 0x30
        X"00000000", X"00000000", X"00000000", X"00000000", -- 0X10 -- 0x40
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000",
        X"00000000", X"00000000", X"00000000", X"00000000"
    );

BEGIN 

BADJI_INSTR_ADDR <= Badji_PC(6 DOWNTO 2);
Badji_Instr <= BADJI_ROM_DATA(TO_INTEGER(UNSIGNED(BADJI_INSTR_ADDR))); --when Badji_PC < x"00000040" else x"00000000";

END instr_mem; 
