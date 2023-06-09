LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY IF_ID_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_RST : IN STD_LOGIC;
        IF_PC_RST : OUT STD_LOGIC;
        IF_Interrupt : OUT STD_LOGIC;
        IF_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_Instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        IF_Instruction_Opcode : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        IF_Instruction_ReadAddr1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_Instruction_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY IF_ID_Buffer;

ARCHITECTURE rtl OF IF_ID_Buffer IS
    SIGNAL SIG_instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- SIGNAL SIG_IF_Instruction_Opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
    -- SIGNAL SIG_IF_Instruction_ReadAddr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL SIG_IF_Instruction_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL SIG_IF_Instruction_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL SIG_IF_Instruction_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
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
        32
        ) PORT MAP (Instruction, clk, rst, enable, SIG_Instruction
    );
    IF_ID_FF_PC : D_FF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, IF_PC
    );
    IF_ID_FF_INTERRUPT : ENTITY work.D_FF_1 PORT MAP(
        interrupt, clk, rst, enable, IF_Interrupt
        );
    IF_ID_FF_RESET : ENTITY work.D_FF_1 PORT MAP(
        PC_RST, clk, '0', enable, IF_PC_RST
        );

    IF_Instruction <= SIG_Instruction;
    IF_Instruction_Opcode <= SIG_Instruction(31 DOWNTO 26);
    IF_Instruction_ReadAddr1 <= SIG_Instruction(25 DOWNTO 23);
    IF_Instruction_ReadAddr2 <= SIG_Instruction(22 DOWNTO 20);
    IF_Instruction_WriteAddr <= SIG_Instruction(19 DOWNTO 17);
    IF_Instruction_ImmediateVal <= SIG_Instruction(15 DOWNTO 0);
END ARCHITECTURE rtl;