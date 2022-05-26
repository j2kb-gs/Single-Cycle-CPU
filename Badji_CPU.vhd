library ieee; 
use ieee.numeric_std.all; 
use ieee.std_logic_signed.all;
use ieee.std_logic_1164.all;

entity Badji_CPU is 
    port (
            Badji_Clock, Badji_Reset: in std_logic; 
            Badji_PC_OUT, Badji_ALU_Result: out std_logic_vector(31 downto 0)
    );
end Badji_CPU; 



architecture CPU of Badji_CPU is 

component Badji_Instruction_Memory
    port (
            Badji_PC : in std_logic_vector(31 downto 0);
            Badji_Instr: out std_logic_vector(31 downto 0)
    );
end component;

component Badji_Data_Memory 
    port (
        Badji_MAR: in std_logic_vector (3 DOWNTO 0); 
        Badji_MDR: in std_logic_vector (31 DOWNTO 0); 
        Badji_WREN : in std_logic ; 
        Badji_Clock: in std_logic; 
        Badji_DataOut: out std_logic_vector(31 DOWNTO 0)
    );
end component;

component Badji_Register_File 
    port (
        Badji_Clock : in std_logic; 
        Badji_Wren  : in std_logic; 
      
        Badji_RegA : in std_logic_vector (4 DOWNTO 0);
        Badji_DataIn : in std_logic_vector (31 DOWNTO 0);
       
        Badji_RegB : in std_logic_vector (4 DOWNTO 0);
        Badji_Read1 : out std_logic_vector (31 DOWNTO 0);
        
        Badji_RegC : in std_logic_vector (4 DOWNTO 0);
        Badji_Read2 : out std_logic_vector (31 DOWNTO 0)
    );
end component;

component Badji_ALU
    port (
        Badji_srcA, Badji_srcB: in std_logic_vector (31 downto 0);
        Badji_ALUctr: in std_logic_vector (3 downto 0);
        Badji_Shamt: in std_logic_vector (4 downto 0);
        Badji_ALUOut: out std_logic_vector (31 downto 0);
        Badji_Ovf, Badji_Neg, Badji_Zero: out std_logic 
    );
end component;

component Badji_Mux_2_1
    generic (n : integer := 32);
    PORT ( 
    BADJI_V, BADJI_W : IN STD_LOGIC_VECTOR (n-1 DOWNTO 0) ;
    BADJI_Sel : IN STD_LOGIC ;
    Badji_MuxOut : OUT STD_LOGIC_VECTOR (n-1 DOWNTO 0) 
    ) ;
end component;

component Badji_Control_Unit
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
end component;

component Badji_Alu_Control
    port (
        Badji_ALUop : in std_logic_vector (1 downto 0);
        Badji_Funct : in std_logic_vector (5 downto 0);
        Badji_ALUctr : out std_logic_vector (3 downto 0)
    );
end component;




signal Badji_currentPC: std_logic_vector(31 downto 0);
signal Badji_nextPC, PC4: std_logic_vector(31 downto 0);
signal Badji_BranchAddr : std_logic_vector(31 downto 0);
signal Badji_JumpAddr : std_logic_vector(31 downto 0);

signal Badji_PC_Branch : std_logic_vector(31 downto 0);

signal Badji_Instr : std_logic_vector(31 downto 0);

signal Badji_ALUop :  std_logic_vector(1 downto 0);
signal Badji_PCsrc :  std_logic;
signal Badji_ALUsrc :  std_logic;
signal Badji_regDst:  std_logic;
signal Badji_RegWr :  std_logic;
signal Badji_MemWr :  std_logic;
signal Badji_ExtOp :  std_logic;
signal Badji_Jmp :  std_logic;
signal Badji_MemToReg :  std_logic; 

signal RtOrRd : std_logic_vector(4 downto 0);
signal Badji_DataIn : std_logic_vector(31 downto 0);
signal Badji_RegB, Badji_RegC: std_logic_vector (4 DOWNTO 0);

signal Badji_Read1 : std_logic_vector(31 downto 0);
signal Badji_Read2 : std_logic_vector(31 downto 0);

signal Badji_ALUctr : std_logic_vector(3 downto 0); 
signal Badji_ALUOut : std_logic_vector(31 downto 0);
signal Badji_Ovf, Badji_Neg, Badji_Zero: std_logic;
signal Badji_DataOut : std_logic_vector(31 downto 0);

signal Badji_AluBus_B : std_logic_vector(31 downto 0);

signal Sign_Temp : std_logic_vector (15 downto 0);
signal Imm_Ext, Sign_Ext, Zero_Ext: std_logic_vector (31 downto 0);

signal EXT_IMM_SHIFT_2 : std_logic_vector (31 downto 0);

signal branch: std_logic; 

begin

process(Badji_Clock, Badji_Reset)
begin
    if(Badji_Reset = '1') then
        Badji_currentPC <= X"00400000";
    elsif (rising_edge(Badji_Clock)) then 
        Badji_currentPC <= Badji_nextPC;
    end if; 
end process; 

PC4 <= Badji_currentPC + x"4";

-- Instruction Fetch **
Instr_Mem: Badji_Instruction_Memory 
        port map (Badji_currentPC, Badji_Instr);

-- Instruction Decode **
Cont_Unit: Badji_Control_Unit 
        port map (Badji_Instr(31 downto 26), Badji_ALUop, BADJI_PCsrc,
                    Badji_ALUsrc, Badji_regDst, Badji_RegWr, Badji_MemWr,
                                    Badji_ExtOp, Badji_Jmp, Badji_MemToReg);

Mux_RegDst: Badji_Mux_2_1 
        generic map (n => 5 ) 
        port map (Badji_Instr(20 downto 16), 
            Badji_Instr(15 downto 11), Badji_regDst, RtOrRd);

    Badji_RegB <= Badji_Instr(25 downto 21);
    Badji_RegC <= Badji_Instr(20 downto 16);

Reg_File: Badji_Register_File
        port map (Badji_Clock, Badji_RegWr, RtOrRd, Badji_DataIn, Badji_RegB, 
                    Badji_Read1, Badji_RegC, Badji_Read2 );

    Sign_Temp <= (others => Badji_Instr(15));
    Sign_Ext <= Sign_Temp & Badji_Instr(15 downto 0);
    Zero_Ext <= X"0000" &  Badji_Instr(15 downto 0);
    Imm_Ext <= sign_Ext when Badji_ExtOp  = '1' else Zero_Ext; 

Alu_Contr: Badji_Alu_Control
        port map (Badji_ALUop, Badji_Instr(5 downto 0), Badji_ALUctr);

    Badji_AluBus_B <= Imm_Ext when Badji_ALUsrc = '1' else Badji_Read2;

-- Execution **
ALU: Badji_ALU
        port map (Badji_Read1, Badji_AluBus_B, Badji_ALUctr, Badji_Instr(10 downto 6),
                Badji_ALUOut, Badji_Ovf, Badji_Neg, Badji_Zero );


    EXT_IMM_SHIFT_2 <= Imm_Ext(29 downto 0) & "00"; 
    Badji_BranchAddr <= PC4 + EXT_IMM_SHIFT_2; 
    Badji_JumpAddr <= "000000" & (Badji_Instr(23 downto 0) & "00");
    
    branch <= Badji_PCsrc and Badji_Zero ; 

    Badji_PC_Branch <= Badji_JumpAddr when Badji_Jmp = '1' else
                        Badji_BranchAddr when branch = '1';
                         

    Badji_nextPC <= Badji_PC_Branch when branch = '1' else PC4; 

-- Data Memory **
Data_Mem: Badji_Data_Memory
         port map (Badji_ALUOut(5 downto 2), badji_Read2, Badji_MemWr, 
                                Badji_Clock, Badji_DataOut );

-- Write Back **
    Badji_DataIn <= Badji_DataOut when Badji_MemToReg = '1' else Badji_ALUOut; 
    
    Badji_PC_Out <= Badji_currentPC;
    Badji_ALU_Result <= Badji_ALUOut;


end CPU;