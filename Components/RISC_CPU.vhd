LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY RISC_CPU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF RISC_CPU IS
    TYPE enum IS (MemRead
        , MemWrite
        , ALUsrc
        , MemToReg
        , Branch
        , Jump
        , RegDst
        , RegWrite
        , PortEN
        , FlagEN);
    TYPE enum_array IS ARRAY (enum) OF INTEGER;
    ---- Control unit Signals
    ---- 0 -> MemRead,
    -- 1 -> MemWrite,
    -- 2 -> ALUsrc,
    -- 3 -> MemToReg,
    -- 4 -> Branch,
    -- 5 -> Jump,
    -- 6 -> RegDst,
    -- 7 -> RegWrite,
    -- 8 -> PortEN,
    -- 9 -> FlagEN,
    -- 12 - 10 -> ALUop
    SIGNAL DecodeStage_ControlSignals : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL DecodeStage_RegFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DecodeStage_RegFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL ExecuteStage_OUTPUT_PORT_VALUE : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ExecuteStage_ALU_Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ExecuteStage_FlagRegisterValue : STD_LOGIC_VECTOR(2 DOWNTO 0);

    ---- Program counter signals
    SIGNAL ProgramCounter_Updated : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Current : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Enable : STD_LOGIC;

    ---- Instruction Memory signals
    SIGNAL InstructionMemory_ReadData : STD_LOGIC_VECTOR(31 DOWNTO 0);

    ---- Data Memory signals
    SIGNAL DataMemory_ReadData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DataMemory_ReadAddr : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- Register file output signals
    SIGNAL RegisterFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RegisterFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ---- Fetch decode buffer signals
    SIGNAL Fetch_Decode_Enable : STD_LOGIC;
    SIGNAL Fetch_Decode_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_Opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ReadAddr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL SignExtended_Immediate : STD_LOGIC_VECTOR(31 DOWNTO 0);

    ---- ID EX buffer signals
    SIGNAL Decode_Execute_Enable : STD_LOGIC;

    ----OUTPUTS
    SIGNAL Decode_Execute_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL Decode_Execute_Out_RegisterFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_RegisterFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Decode_Execute_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Decode_Execute_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_SP : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ---- Port signals
    SIGNAL OUTPUT_PORT_VALUE : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL INPUT_PORT_VALUE : STD_LOGIC_VECTOR(2 DOWNTO 0);

    --- Execute Memory 1 buffer signals

    --- Inputs
    SIGNAL Execute_Mem1_In_Enable : STD_LOGIC;

    --- Outputs
    SIGNAL Execute_Mem1_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_FlagRegister : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_RegisterFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_ALU_Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_SP : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Execute_Mem1_Out_PORTOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- M1 M2 buffer signals
    SIGNAL MEM1_MEM2_Enable : STD_LOGIC;

    ----OUTPUTS
    SIGNAL MEM1_MEM2_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_FLAGREGISTER : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Mem1_MEM2_Out_PORTOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    -- M2 WB buffer signals
    SIGNAL MEM2_WB_Enable : STD_LOGIC;

    ----OUTPUTS
    SIGNAL MEM2_WB_Out_WriteBackAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_WriteBackData : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    ProgramCounter_Enable <= '1';
    ProgramCounter : ENTITY work.D_FF GENERIC MAP (
        16
        ) PORT MAP (ProgramCounter_Updated,
        clk,
        reset,
        ProgramCounter_Enable,
        ProgramCounter_Current
        );

    Instruction_Memory : ENTITY work.Memory GENERIC MAP (
        32, 1024
        ) PORT MAP (
        ReadAddr => ProgramCounter_Current,
        ReadData => InstructionMemory_ReadData,
        we => '0',
        clk => clk,
        WriteData => (OTHERS => '0')
        );
    ----------------------- Pipeline buffers -----------------------
    ----------------------- ==== Fetch decode buffer ==== -----------------------
    Fetch_Decode_Buffer : ENTITY work.IF_ID_Buffer PORT MAP (
        --- Inputs
        clk => clk,
        enable => Fetch_Decode_Enable,
        rst => reset,
        Instruction => InstructionMemory_ReadData,
        PC => ProgramCounter_Current,
        --- Outputs
        IF_PC => Fetch_Decode_PC,
        IF_Instruction => Fetch_Decode_Instruction,
        IF_Instruction_Opcode => Fetch_Decode_Instruction_Opcode,
        IF_Instruction_ReadAddr1 => Fetch_Decode_Instruction_ReadAddr1,
        IF_Instruction_ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
        IF_Instruction_WriteAddr => Fetch_Decode_Instruction_WriteAddr,
        IF_Instruction_ImmediateVal => Fetch_Decode_Instruction_ImmediateVal
        );
    decode_stage_inst : ENTITY work.Decode_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            reset => reset,
            IF_ID_Instruction => Fetch_Decode_Instruction,
            IF_ID_ReadAddr1 => Fetch_Decode_Instruction_ReadAddr1,
            IF_ID_ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
            MEM2_WB_RegisterFile_WriteData => MEM2_WB_Out_WriteBackData,
            MEM2_WB_RegisterFile_WriteAddr => MEM2_WB_Out_WriteBackAddr,
            --- Outputs
            IF_ID_ControlSignals => DecodeStage_ControlSignals,
            RegFile_ReadData1 => DecodeStage_RegFile_ReadData1,
            RegFile_ReadData2 => DecodeStage_RegFile_ReadData2
        );

    Decode_Execute_Buffer : ENTITY work.ID_EX_Buffer PORT MAP (
        --- Inputs    
        enable => Decode_Execute_Enable,
        clk => clk,
        rst => reset,
        ControlUnitOutput => DecodeStage_ControlSignals,
        RegisterFile_ReadData1 => DecodeStage_RegFile_ReadData1,
        RegisterFile_ReadData2 => DecodeStage_RegFile_ReadData2,

        WriteAddr => Fetch_Decode_Instruction_WriteAddr,
        ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
        ImmediateVal => Fetch_Decode_Instruction_ImmediateVal,
        PC => Fetch_Decode_PC,

        --- Outputs
        ID_ControlUnitOutput => Decode_Execute_Out_ControlUnitOutput,
        ID_RegisterFile_ReadData1 => Decode_Execute_Out_RegisterFile_ReadData1,
        ID_RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
        ID_WriteAddr => Decode_Execute_Out_WriteAddr,
        ID_ReadAddr2 => Decode_Execute_Out_ReadAddr2,
        ID_ImmediateVal => Decode_Execute_Out_ImmediateVal,
        ID_PC => Decode_Execute_Out_PC,
        ID_SP => Decode_Execute_Out_SP
        );

    execute_stage_inst : ENTITY work.Execute_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            reset => reset,
            ID_EX_ControlSignals => Decode_Execute_Out_ControlUnitOutput,
            ID_EX_RegisterFile_ReadData1 => Decode_Execute_Out_RegisterFile_ReadData1,
            ID_EX_RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
            ID_EX_RegisterFile_ImmediateVal => Decode_Execute_Out_ImmediateVal,
            flagRegisterUpdateCircuit_dataMem => ---- from ali in memory2,
            ,
            --- Outputs
            OUTPUT_PORT_VALUE => ExecuteStage_OUTPUT_PORT_VALUE,
            ALU_Result => ExecuteStage_ALU_Result,
            FlagRegisterValue => ExecuteStage_FlagRegisterValue
        );
    ex_mem1_buffer_inst : ENTITY work.EX_MEM1_Buffer
        PORT MAP(
            --- Inputs
            clk => clk,
            enable => Execute_Mem1_Enable,
            rst => reset,
            ControlUnitOutput => Decode_Execute_Out_ControlUnitOutput,
            FlagRegister => ExecuteStage_FlagRegisterValue,
            RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
            WriteAddr => Decode_Execute_Out_WriteAddr,
            ReadAddr2 => Decode_Execute_Out_ReadAddr2,
            ImmediateVal => Decode_Execute_Out_ImmediateVal,
            ALU_Result => ExecuteStage_ALU_Result,
            PC => Decode_Execute_Out_PC,
            SP => Decode_Execute_Out_SP,
            PORTOUT => ExecuteStage_OUTPUT_PORT_VALUE,

            --- Outputs
            EX_ControlUnitOutput => Execute_Mem1_Out_ControlUnitOutput,
            EX_FlagRegister => Execute_Mem1_Out_FlagRegister,
            EX_RegisterFile_ReadData2 => Execute_Mem1_Out_RegisterFile_ReadData2,
            EX_WriteAddr => Execute_Mem1_Out_WriteAddr,
            EX_ReadAddr2 => Execute_Mem1_Out_ReadAddr2,
            EX_ImmediateVal => Execute_Mem1_Out_ImmediateVal,
            EX_ALU_Result => Execute_Mem1_Out_ALU_Result,
            EX_PC => Execute_Mem1_Out_PC,
            EX_SP => Execute_Mem1_Out_SP,
            EX_PORTOUT => Execute_Mem1_Out_PORTOUT
        );
    memory1_stage_inst : ENTITY work.Memory1_Stage
        PORT MAP(
            --- Inputs
            jump => Execute_Mem1_Out_ControlUnitOutput(5),
            alu_src => Execute_Mem1_Out_ControlUnitOutput(2),
            StackPointer => Execute_Mem1_Out_SP,
            ALU_Result => Execute_Mem1_Out_ALU_Result,
            Decode_Execute_Out_PC => Execute_Mem1_Out_PC,
            Execute_Mem1_Out_FlagRegister => Execute_Mem1_Out_FlagRegister,
            ReadData2 => Execute_Mem1_Out_RegisterFile_ReadData2,

            --- Outputs
            DataMemory_ReadData => DataMemory_ReadData,
            DataMemory_ReadAddr => DataMemory_ReadAddr
        );
    mem1_mem2_buffer_inst : ENTITY work.MEM1_MEM2_Buffer
        PORT MAP(
            clk => clk,
            enable => MEM1_MEM2_Enable,
            rst => reset,
            ControlUnitOutput => Execute_Mem1_Out_ControlUnitOutput,
            FlagRegister => Execute_Mem1_Out_FlagRegister,
            WriteAddr => Execute_Mem1_Out_WriteAddr,
            ReadAddr2 => Execute_Mem1_Out_ReadAddr2,
            ImmediateVal => Execute_Mem1_Out_ImmediateVal,
            ALU_Result => Execute_Mem1_Out_ALU_Result,
            PC => Execute_Mem1_Out_PC,
            PORTOUT => Execute_Mem1_Out_PORTOUT,

            MEM1_ControlUnitOutput => MEM1_MEM2_Out_ControlUnitOutput,
            MEM1_FLAGREGISTER => MEM1_MEM2_Out_FLAGREGISTER,
            MEM1_WriteAddr => MEM1_MEM2_Out_WriteAddr,
            MEM1_ReadAddr2 => MEM1_MEM2_Out_ReadAddr2,
            MEM1_ImmediateVal => MEM1_MEM2_Out_ImmediateVal,
            MEM1_ALU_RESULT => MEM1_MEM2_Out_ALU_RESULT,
            MEM1_PC => MEM1_MEM2_Out_PC,
            MEM1_PORTOUT => MEM1_MEM2_Out_PORTOUT
        );

    memory2_stage_inst : ENTITY work.Memory2_Stage
        PORT MAP(
            clk => clk,
            DataMemory_ReadAddr => DataMemory_ReadAddr,
            WriteData => WriteData,
            SIG_MemWrite => SIG_MemWrite,
            Write_enable => Write_enable,
            SIG_MemRead => SIG_MemRead,
            SIG_MemToReg => SIG_MemToReg,
            SIG_Branch => SIG_Branch,
            SIG_Jump => SIG_Jump,
            SIG_ALUop => SIG_ALUop,
            Zero_flag => Zero_flag,
            Carry_flag => Carry_flag,
            Flag_en => Flag_en,
            Port_en => Port_en,
            RegDst => RegDst,
            PC => PC,
            PC_out => PC_out,
            Input_value => Input_value,
            Input_enable => Input_enable,
            Immediate_value => Immediate_value,
            Write_data_RDST => Write_data_RDST,
            PC_Mux_out => PC_Mux_out,
            ALU_Result => ALU_Result,
            Write_back_address_mux_2x1_in0 => Write_back_address_mux_2x1_in0,
            Write_back_address_mux_2x1_in1 => Write_back_address_mux_2x1_in1,
            Write_back_address_mux_2x1_out => Write_back_address_mux_2x1_out
        );

    mem2_wb_buffer_inst : ENTITY work.MEM2_WB_Buffer
        PORT MAP(
            clk => clk,
            enable => MEM2_WB_Enable,
            rst => reset,
            WriteBackAddr = >,
            WriteBackData = >,
            PORTOUT => Mem1_MEM2_Out_PORTOUT,

            MEM2_WriteBackAddr => MEM2_WB_Out_WriteBackAddr,
            MEM2_WriteBackData => MEM2_WB_Out_WriteBackData,
            MEM2_PORTOUT => MEM2_WB_Out_PORTOUT
        );

    ----------------------- Pipeline buffers -----------------------
    output_port_inst : ENTITY work.OUTPUT_PORT
        GENERIC MAP(
            16)
        PORT MAP(
            port_value => OUTPUT_PORT_VALUE,
            enable => enable,
            out_value => out_value
        );

END ARCHITECTURE;