library ieee; 
use ieee.std_logic_1164.all;

entity Badji_Alu_Control is 
  port (
    Badji_ALUop : in std_logic_vector (1 downto 0);
    Badji_Funct : in std_logic_vector (5 downto 0);
    Badji_ALUctr : out std_logic_vector (3 downto 0)
  ); 
end Badji_Alu_Control; 

architecture AluControl of Badji_Alu_Control is
begin 
    Badji_ALUctr <= "0010" when Badji_ALUop = "00" or (Badji_ALUop = "10" and Badji_Funct = "100000") else -- add, addi
                    "0110" when Badji_ALUop = "01" or (Badji_ALUop = "10" and Badji_Funct = "100010") else -- sub, branch
                    "0011" when (Badji_ALUop = "10" and Badji_Funct = "100001") else -- addu
                    "0111" when (Badji_ALUop = "10" and Badji_Funct = "100011") else -- subu
                    "0000" when (Badji_ALUop = "10" and Badji_Funct = "100100") else -- and
                    "0001" when (Badji_ALUop = "10" and Badji_Funct = "100101") else -- or
                    "1100" when (Badji_ALUop = "10" and Badji_Funct = "100111") else -- nor
                    "1000" when (Badji_ALUop = "10" and Badji_Funct = "000000") else -- sll
                    "1001" when (Badji_ALUop = "10" and Badji_Funct = "000010") else -- srl
                    "1011" when (Badji_ALUop = "10" and Badji_Funct = "000011") else -- sra
                    "0000" when (Badji_ALUop = "10" ) else -- andi
                    "0001" when (Badji_ALUop = "11" ) else -- ori
                    "0010";

end AluControl;