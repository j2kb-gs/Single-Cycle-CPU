LIBRARY iEEE; 
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

-----------------------------------
-- 32 X 32 DATA MEMORY - SINGLE PORT
-----------------------------------

ENTITY Badji_Data_Memory IS 
PORT (
        BADJI_MAR: IN STD_LOGIC_VECTOR (3 DOWNTO 0); 
        BADJI_MDR: IN STD_LOGIC_VECTOR (31 DOWNTO 0); 
        BADJI_WREN : IN STD_LOGIC ; 
        BADJI_CLOCK: IN STD_LOGIC; 
        BADJI_DataOut: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END Badji_Data_Memory;

ARCHITECTURE data_memory OF Badji_Data_Memory IS 
-- DEFINE THE ARRAY OF ADDRESSES
TYPE BADJI_RAM_ARRAY IS ARRAY (0 TO 15) OF STD_LOGIC_VECTOR (31 DOWNTO 0); 

SIGNAL BADJI_RAM: BADJI_RAM_ARRAY := 
                    (
                        X"0000000a", X"00000014", X"0000001e", X"00000028",    -- X"00"
                        X"00000032", X"00000000", X"00000000", X"00000000",    -- X"04"
                        X"00000000", X"00000000", X"00000000", X"00000000",    -- X"08"
                        X"00000000", X"00000000", X"00000000", X"00000000"    -- X"0C"
                   
                    );

BEGIN 

PROCESS (BADJI_CLOCK)
    BEGIN
        IF (RISING_EDGE (BADJI_CLOCK)) THEN 
            IF (BADJI_WREN = '1') THEN
                -- INPUT DATA WILL BE THE OUTPUT
                BADJI_RAM(TO_INTEGER(UNSIGNED(BADJI_MAR))) <= BADJI_MDR; 
                -- [INDEX] OF THE RAM ARRAY TYPE NEEDS TO BE POSITIVE 
                -- SO WE CONVERT FROM STD_LOGIC_VECTOR TO UNSIGNED INT
            END IF; 
        END IF; 
    END PROCESS; 

BADJI_DataOut <=  BADJI_RAM(TO_INTEGER(UNSIGNED(BADJI_MAR))); 

END data_memory; 