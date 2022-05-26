LIBRARY ieee ;
USE ieee.std_logic_1164.all ;
use ieee.std_logic_signed.all; 

entity Badji_TB_CPU is 

end Badji_TB_CPU;

architecture TB_CPU of Badji_TB_CPU is 

component Badji_CPU is 
port (
        Badji_Clock, Badji_Reset: in std_logic; 
        Badji_PC_OUT, Badji_ALU_Result: out std_logic_vector(31 downto 0)
);
end component;


signal Badji_Clock, Badji_Reset:  std_logic; 
signal Badji_PC_OUT, Badji_ALU_Result:  std_logic_vector(31 downto 0);


constant Clock_Period : time := 10 ns; 

begin 
Inst_CPU: Badji_CPU 
            port map ( Badji_Clock, Badji_Reset,
                    Badji_PC_OUT, Badji_ALU_Result);

Clock_Process: process
begin

    Badji_Clock <= '0'; 
    wait for Clock_Period/2;
    Badji_Clock <= '1'; 
    wait for Clock_Period/2;

end process; 

Sim_Process: process
begin 

    Badji_Reset <= '1'; 
    wait for Clock_Period*10; 
    Badji_Reset <= '0'; 

    wait;
end process; 




end TB_CPU; 