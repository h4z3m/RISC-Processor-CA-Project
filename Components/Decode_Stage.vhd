LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Decode_Stage IS
    PORT (
        -- Inputs
        clk, reset : IN STD_LOGIC;
        PC_Reset : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        update_pc_carry : IN STD_LOGIC;
        update_pc_zero : IN STD_LOGIC;
        interrupt_buffered : IN STD_LOGIC;
        LoadUseCase_Stall : IN STD_LOGIC;
        StructuralHazard_Stall : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        External_Instruction_type : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        IF_ID_Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        IF_ID_ReadAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        EX_M1_RegWrite : IN STD_LOGIC;
        EX_M1_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_M1_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_M1_RegDst : IN STD_LOGIC;

        ID_EX_ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RegDst : IN STD_LOGIC;
        ID_EX_RegWrite : IN STD_LOGIC;
        M1_immediate : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        Execute_ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        M1_M2_RegWrite : IN STD_LOGIC;
        MEM1_MEM2_WB_Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_MEM2_WB_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        MEM2_WB_RegisterFile_WriteData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_WB_RegisterFile_WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RegFile_RegWrite_Enable : IN STD_LOGIC;

        Zero_Flag : IN STD_LOGIC;
        Carry_Flag : IN STD_LOGIC;
        -- Outputs
        PC_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Interrupt_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        IF_ID_ControlSignals : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        RegFile_ReadData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegFile_ReadData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Decode_Stage;

ARCHITECTURE rtl OF Decode_Stage IS
    SIGNAL TEMP_IF_ID_ControlSignals : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL PC_RDST : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL TEMP_RegFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
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
        WR_ENABLE => RegFile_RegWrite_Enable,
        WRITE_PORT => MEM2_WB_RegisterFile_WriteData,
        WRITE_ADDR => MEM2_WB_RegisterFile_WriteAddr,
        READ_ADDR_1 => IF_ID_ReadAddr1,
        READ_PORT_1 => RegFile_ReadData1,
        READ_ADDR_2 => IF_ID_ReadAddr2,
        READ_PORT_2 => RegFile_ReadData2);
    IF_ID_ControlSignals <= TEMP_IF_ID_ControlSignals;
    TEMP_RegFile_ReadData1 <= RegFile_ReadData1;
    execution_forwarding_unit_inst : ENTITY work.Execution_Forwarding_unit
        PORT MAP(
            -- Inputs
            M1_M2_WB_Addr => MEM1_MEM2_WB_Addr,
            IF_ID_RS => IF_ID_ReadAddr1,

            ID_EX_RT => ID_EX_ReadAddr2,
            ID_EX_RD => ID_EX_WriteAddr,
            ID_EX_RegWrite => ID_EX_RegWrite,

            ID_EX_RegDst => ID_EX_RegDst,
            M1_M2_RegWrite => M1_M2_RegWrite,

            EX_M1_RegWrite => EX_M1_RegWrite,
            EX_M1_RD => EX_M1_RD,
            EX_M1_RT => EX_M1_RT,
            EX_M1_RegDst => EX_M1_RegDst,

            wb_data => MEM1_MEM2_WB_Data,
            alu_result => Execute_ALU_Result,
            read_data1 => TEMP_RegFile_ReadData1,

            -- Outputs
            alu_immediate => M1_immediate,
            rdst_out => PC_RDST
        );

    updatepccircuit_inst : ENTITY work.updatePCcircuit
        PORT MAP(
            SIG_Branch => TEMP_IF_ID_ControlSignals(4),
            SIG_Jump => TEMP_IF_ID_ControlSignals(5),
            SIG_AluOP0 => TEMP_IF_ID_ControlSignals(10),
            Reset => reset,
            reset_buffered => PC_Reset,
            Interrupt => Interrupt,
            interrupt_buffered => interrupt_buffered,
            Zero_flag => update_pc_zero,
            Carry_flag => update_pc_carry,
            type_sig => IF_ID_Instruction(31 DOWNTO 30),
            external_type_sig => External_Instruction_type,
            rdst => PC_RDST,
            LoadUseCase_Stall => LoadUseCase_Stall,
            Structural_Stall => StructuralHazard_Stall,
            PC => PC,
            PC_out => PC_out
        );

    PC_Interrupt_Out <= STD_LOGIC_VECTOR(unsigned(IF_ID_PC) + 2) WHEN IF_ID_Instruction(31 DOWNTO 30) = "00" ELSE
    STD_LOGIC_VECTOR(unsigned(IF_ID_PC) + 1);

END ARCHITECTURE rtl;