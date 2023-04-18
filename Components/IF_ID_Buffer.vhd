LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY IF_ID_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_Instruction_Opcode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        IF_Instruction_ReadAddr1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY IF_ID_Buffer;

ARCHITECTURE rtl OF IF_ID_Buffer IS
    SIGNAL SIG_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL SIG_IF_Instruction_Opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL SIG_IF_Instruction_ReadAddr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SIG_IF_Instruction_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SIG_IF_Instruction_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL SIG_IF_Instruction_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    COMPONENT D_FF IS
        GENERIC (
            N : INTEGER := 16
        );
        PORT (
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            CLK, RST, EN : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    IF_ID_FF : D_FF GENERIC MAP(
        6
        ) PORT MAP (Instruction, clk, rst, enable, SIG_Instruction
    );

    SIG_IF_Instruction_Opcode <= SIG_Instruction(31 DOWNTO 26);
    SIG_IF_Instruction_ReadAddr1 <= SIG_Instruction(25 DOWNTO 23);
    SIG_IF_Instruction_ReadAddr2 <= SIG_Instruction(22 DOWNTO 20);
    SIG_IF_Instruction_WriteAddr <= SIG_Instruction(19 DOWNTO 17);
    SIG_IF_Instruction_ImmediateVal <= SIG_Instruction(15 DOWNTO 0);
END ARCHITECTURE rtl;