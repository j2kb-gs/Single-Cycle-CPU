library ieee; 
use ieee.std_logic_1164.all;

entity Badji_Control_Unit is 
    port (
        Badji_opCode : in std_logic_vector(5 downto 0);
        Badji_ALUop : out std_logic_vector(1 downto 0);
        Badji_PCsrc : out std_logic;
        Badji_ALUsrc : out std_logic;
        Badji_regDst: out std_logic;
        Badji_RegWr : out std_logic;
        Badji_MemWr : out std_logic;
        Badji_ExtOp : out std_logic;
        Badji_Jmp : out std_logic;
        Badji_MemToReg : out std_logic 
    ); 
end Badji_Control_Unit; 

architecture ControlUnit of Badji_Control_Unit is 

begin 
    Badji_regDst <= '1' when Badji_opCode ="000000" else --R type 
                    '0' ;--when Badji_opCode ="100011" or Badji_opCode > "000111" else --lw and I type
                    --'X'; -- branch , sw

    Badji_ALUsrc <= '0' when Badji_opCode = "000000" or Badji_opCode = "000100" or 
                             Badji_opCode = "000101" else -- R type , branch
                    '1'; -- I type

    Badji_PCsrc  <= '1' when Badji_opCode = "000100" or Badji_opCode = "000101" or 
                             Badji_opCode = "000010" else -- branch
                    '0'; 

    Badji_RegWr  <= '0' when Badji_opCode = "101011" or Badji_opCode = "000100" or
                             Badji_opCode = "000101" or Badji_opCode = "000010" else -- sw, branch
                    '1'; 
                        
    Badji_MemWr  <= '1' when Badji_opCode = "101011" else -- sw
                    '0';
        
    Badji_MemToReg <= '1' when Badji_opCode = "100011" else -- lw
                      '0';

    Badji_ExtOp    <= '0' when Badji_opCode = "001101" or Badji_opCode = "001100" else 
                      '1'; 
    
    Badji_Jmp      <= '1' when Badji_opCode = "000010" else 
                      '0'; 

    Badji_ALUop  <= "00" when Badji_opCode = "101011" or Badji_opCode = "100011" or
                              Badji_opCode = "001000" or Badji_opCode = "001001" else -- sw, lw, addi
                    "01" when Badji_opCode = "000100" or Badji_opCode = "000101" else -- branch
                    "11" when Badji_opCode = "001101" else -- ori
                    "10"; -- R type



end ControlUnit; 