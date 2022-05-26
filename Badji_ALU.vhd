library ieee; 
use ieee.numeric_std.all; 
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;


entity Badji_ALU is 
  port (
      Badji_srcA, Badji_srcB: in std_logic_vector (31 downto 0);
      Badji_ALUctr: in std_logic_vector (3 downto 0);
      Badji_Shamt: in std_logic_vector (4 downto 0);
      Badji_ALUOut: out std_logic_vector (31 downto 0);
      Badji_Ovf, Badji_Neg, Badji_Zero: out std_logic 
 ); 
end Badji_ALU; 

architecture ALU_Unit of Badji_ALU is
    signal offset: integer;
    signal Badji_Result : std_logic_vector (32 downto 0);
    signal Badji_ZeroTemp: std_logic_vector (31 downto 0);
    signal Badji_SignTemp: std_logic_vector (31 downto 0);

    begin
        Badji_ZeroTemp <= X"00000000";  
        Badji_SignTemp <= (others => Badji_srcB(31));
        offset <= to_integer(unsigned(Badji_Shamt));

        process (Badji_ALUctr, Badji_srcA, Badji_srcB, Badji_Shamt )
        begin 
            case Badji_ALUctr is 
            when "0000" => -- and
                Badji_Result <= ('0' & Badji_srcA) and ('0' & Badji_srcB) ;
            when "0001" => -- or
                Badji_Result <= ('0' & Badji_srcA) or ('0' & Badji_srcB) ;
            when "0010" => -- add
                Badji_Result <= ('0' & Badji_srcA) + ('0' & Badji_srcB) ;
            when "0110" => -- sub
                Badji_Result <= ('0' & Badji_srcA) - ('0' & Badji_srcB) ;
            when "0011" => -- addu
                Badji_Result <= ('0' & Badji_srcA) + ('0' & Badji_srcB) ;
            when "0111" => -- subu
                Badji_Result <= ('0' & Badji_srcA) - ('0' & Badji_srcB) ;

            when "1000" => -- sll
                Badji_Result <=  '0' & (Badji_srcB((31 - offset) downto 0) & 
                                    Badji_ZeroTemp((offset - 1) downto 0) );
            when "1001" => -- srl
                Badji_Result <=  '0' & (Badji_ZeroTemp((offset - 1) downto 0) & 
                                    Badji_srcB(31 downto offset) );
            when "1011" => -- sra
                Badji_Result <=  '0' & (Badji_SignTemp((offset - 1) downto 0) & 
                                    Badji_srcB(31 downto offset) );

            when others => Badji_Result <= '0' & X"00000000";
            end case; 
        end process; 

        Badji_ALUOut <= Badji_Result(31 downto 0);
        Badji_Zero <= '1' when Badji_Result = X"00000000" else '0'; 
        Badji_Ovf  <= '0' when Badji_ALUctr = "0011" or  Badji_ALUctr = "0111" else -- addu, subu
                    Badji_Result(32) xor Badji_Result (31);
        Badji_Neg <= Badji_Result(31);
            

end ALU_Unit;