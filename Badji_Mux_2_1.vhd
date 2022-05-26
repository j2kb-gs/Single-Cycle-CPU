----------------------------------------------------------------------
--------------------------- MUX 2 TO 1 -------------------------------
----------------------------------------------------------------------
LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_signed.all; 

ENTITY Badji_Mux_2_1 IS
    generic (n : integer := 32);
    PORT ( 
        BADJI_V, BADJI_W : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0) ;
        BADJI_Sel : IN STD_LOGIC ;
        Badji_MuxOut : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0) ) ;

END Badji_Mux_2_1 ;

ARCHITECTURE Mux_2_1 OF Badji_Mux_2_1 IS
BEGIN
    PROCESS ( BADJI_V, BADJI_W, BADJI_Sel )
        BEGIN
        IF BADJI_Sel = '0' THEN
            Badji_MuxOut <= BADJI_V ;
        ELSE
            Badji_MuxOut <=BADJI_W ;
        END IF ;
    END PROCESS ;
END Mux_2_1 ;
