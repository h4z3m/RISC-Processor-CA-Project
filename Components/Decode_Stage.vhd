LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Decode_Stage IS
    PORT (
        clk, reset : IN STD_LOGIC;
        IF_ID_Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IF_ID_ReadAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_WB_RegisterFile_WriteData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_WB_RegisterFile_WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        IF_ID_ControlSignals : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        RegFile_ReadData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegFile_ReadData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Decode_Stage;

ARCHITECTURE rtl OF Decode_Stage IS
    SIGNAL TEMP_IF_ID_ControlSignals : STD_LOGIC_VECTOR(12 DOWNTO 0);
BEGIN
    ControlUnit : ENTITY WORK.ControlUnit PORT MAP (
        Instruction => IF_ID_Instruction,
        SIG_MemRead => TEMP_IF_ID_ControlSignals(0),
        SIG_MemWrite => TEMP_IF_ID_ControlSignals(1),
        SIG_ALUsrc => TEMP_IF_ID_ControlSignals(2),
        SIG_MemToReg => TEMP_IF_ID_ControlSignals(3),
        SIG_Branch => TEMP_IF_ID_ControlSignals(4),
        SIG_Jump => TEMP_IF_ID_ControlSignals(5),
        SIG_RegDst => TEMP_IF_ID_ControlSignals(6),
        SIG_RegWrite => TEMP_IF_ID_ControlSignals(7),
        SIG_PortEN => TEMP_IF_ID_ControlSignals(8),
        SIG_FlagEN => TEMP_IF_ID_ControlSignals(9),
        SIG_ALUop => TEMP_IF_ID_ControlSignals(12 DOWNTO 10)
        );
    RegFile : ENTITY WORK.RegisterFile GENERIC MAP (
        DATA_WIDTH => 16,
        REG_COUNT => 8
        )PORT MAP (
        CLK => clk,
        rst => reset,
        WR_ENABLE => TEMP_IF_ID_ControlSignals(7),
        WRITE_PORT => MEM2_WB_RegisterFile_WriteData,
        WRITE_ADDR => MEM2_WB_RegisterFile_WriteAddr,
        READ_ADDR_1 => IF_ID_ReadAddr1,
        READ_PORT_1 => RegFile_ReadData1,
        READ_ADDR_2 => IF_ID_ReadAddr2,
        READ_PORT_2 => RegFile_ReadData2);
    IF_ID_ControlSignals <= TEMP_IF_ID_ControlSignals;
END ARCHITECTURE rtl;