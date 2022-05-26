library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.all; 

ENTITY Badji_Register_File IS 

    PORT (
        Badji_Clock : IN STD_LOGIC; 
        Badji_Wren  : IN STD_LOGIC; 
        -- REGISTER RD
        Badji_RegA : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        Badji_DataIn : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        -- REGISTER RT
        Badji_RegB : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        Badji_Read1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        -- REGISTER RS
        Badji_RegC : IN STD_LOGIC_VECTOR (4 DOWNTO 0);
        Badji_Read2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)

    );
END Badji_Register_File;

ARCHITECTURE RegisterFile OF Badji_Register_File IS 

TYPE BADJI_REG_TYPE IS ARRAY (0 TO 31 ) OF STD_LOGIC_VECTOR (31 DOWNTO 0);
SIGNAL BADJI_REG_ARRAY : BADJI_REG_TYPE := 
            (
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"00"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"04"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"08"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"0C"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"10"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"14"
            X"00000000", X"00000000", X"00000000", X"00000000",    -- X"18"
            X"00000000", X"00000000", X"00000000", X"00000000"     -- X"1C"
            );

BEGIN
    PROCESS (Badji_Clock)
    BEGIN 

    IF (RISING_EDGE (Badji_Clock)) THEN 
        IF (Badji_Wren = '1') THEN 
            BADJI_REG_ARRAY(TO_INTEGER(UNSIGNED(Badji_RegA))) <= Badji_DataIn; 
        END IF;
    END IF;
    END PROCESS; 

    Badji_Read1 <= X"00000000" WHEN Badji_RegB = "00000" ELSE 
                                            BADJI_REG_ARRAY(TO_INTEGER(UNSIGNED(Badji_RegB)));

    Badji_Read2 <= X"00000000" WHEN Badji_RegC = "00000" ELSE 
                                            BADJI_REG_ARRAY(TO_INTEGER(UNSIGNED(Badji_RegC)));

END RegisterFile; 