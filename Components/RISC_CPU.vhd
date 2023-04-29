LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY RISC_CPU IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        in_port : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        out_port : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        INPUT_PORT_VALUE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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

    SIGNAL Memory1_WritebackRegAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);

    ---- Program counter signals
    SIGNAL ProgramCounter_Updated : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Current : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Enable : STD_LOGIC;

    ---- Stack pointer signals
    SIGNAL StackPointer_Updated : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL StackPointer_Current : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- Instruction Memory signals
    SIGNAL InstructionMemory_ReadData : STD_LOGIC_VECTOR(31 DOWNTO 0);

    ---- Data Memory signals
    SIGNAL DataMemory_WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);
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
    SIGNAL OUTPUT_PORT_VALUE : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --- Execute Memory 1 buffer signals

    --- Inputs
    SIGNAL Execute_Mem1_Enable : STD_LOGIC;

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
    -- SIGNAL MEM1_MEM2_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL MEM1_MEM2_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_Writeback_RegAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Mem1_MEM2_Out_PORTOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL MEM1_MEM2_Out_DataMemory_ReadAddr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Mem1_MEM2_Out_DataMemory_WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);

    -- M2 WB buffer signals
    SIGNAL MEM2_WB_Enable : STD_LOGIC;
    SIGNAL MEM2_WB_IN_WriteBackAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_IN_WriteBackData : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ----OUTPUTS
    SIGNAL MEM2_WB_Out_WriteBackAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_WriteBackData : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM2_WB_OutControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL Memory_ReturnInterrupt_Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL mux_before_pc_out : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux_before_memory_out: STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    --------------------Enable all buffers -------------------
    Fetch_Decode_Enable <= '1';
    Decode_Execute_Enable <= '1';
    Execute_Mem1_Enable <= '1';
    MEM1_MEM2_Enable <= '1';
    MEM2_WB_Enable <= '1';
    --------------------Enable all buffers -------------------

    ProgramCounter_Enable <= '1';

    mux_inst : ENTITY work.MUX
        GENERIC MAP(
            n => 16
        )
        PORT MAP(
            in0 => ProgramCounter_Updated,
            in1 =>  InstructionMemory_ReadData(15 downto 0),
            sel => reset OR interrupt,
            out1 => mux_before_pc_out
        );

    mux_4x1_inst : ENTITY work.MUX_4x1
        GENERIC MAP(
            n => 16
        )
        PORT MAP(
            in0 => ProgramCounter_Current,
            in1 => "0000000000000000",
            in2 => "0000000000000001",
            in3 => "0000000000000000",
            sel => interrupt & reset,
            out1 => mux_before_memory_out
        );
    ProgramCounter : ENTITY work.D_FF GENERIC MAP (
        16
        ) PORT MAP (mux_before_pc_out,
        clk,
        '0',
        ProgramCounter_Enable,
        ProgramCounter_Current
        );
    StackPointer : ENTITY work.D_FF
        GENERIC MAP(
            16)
        PORT MAP(
            D => StackPointer_Updated,
            CLK => CLK,
            RST => reset,
            EN => '1',
            Q => StackPointer_Current
        );
    Instruction_Memory : ENTITY work.Memory GENERIC MAP (
        32, 1024
        ) PORT MAP (
        ReadAddr => mux_before_memory_out(9 DOWNTO 0),
        ReadData => InstructionMemory_ReadData,
        write_enable => '0',
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
            SP_currentValue => StackPointer_Current,
            RegFile_RegWrite_Enable => MEM2_WB_OutControlUnitOutput(7),
            --- Outputs
            IF_ID_ControlSignals => DecodeStage_ControlSignals,
            RegFile_ReadData1 => DecodeStage_RegFile_ReadData1,
            RegFile_ReadData2 => DecodeStage_RegFile_ReadData2,
            SP_UpdatedValue => StackPointer_Updated
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
        SP => StackPointer_Updated,

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
            flagRegisterUpdateCircuit_dataMem => Memory_ReturnInterrupt_Out,
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
            Write_back_address_mux_2x1_in0 => Execute_Mem1_Out_WriteAddr,
            Write_back_address_mux_2x1_in1 => Execute_Mem1_Out_ReadAddr2,
            SIG_RegDst => Execute_Mem1_Out_ControlUnitOutput(6),

            --- Outputs
            DataMemory_WriteData => DataMemory_WriteData,
            DataMemory_ReadAddr => DataMemory_ReadAddr,
            Write_back_address_mux_2x1_out => Memory1_WritebackRegAddr
        );

    mem1_mem2_buffer_inst : ENTITY work.MEM1_MEM2_Buffer
        PORT MAP(
            -- Inputs

            clk => clk,
            enable => MEM1_MEM2_Enable,
            rst => reset,
            ControlUnitOutput => Execute_Mem1_Out_ControlUnitOutput,
            FlagRegister => Execute_Mem1_Out_FlagRegister,
            Writeback_RegAddr => Memory1_WritebackRegAddr,
            ImmediateVal => Execute_Mem1_Out_ImmediateVal,
            ALU_Result => Execute_Mem1_Out_ALU_Result,
            PC => Fetch_Decode_PC,
            PORTOUT => Execute_Mem1_Out_PORTOUT,
            DataMemory_ReadAddr => DataMemory_ReadAddr,
            DataMemory_WriteData => DataMemory_WriteData,

            -- Ouputs
            MEM1_ControlUnitOutput => MEM1_MEM2_Out_ControlUnitOutput,
            MEM1_FLAGREGISTER => MEM1_MEM2_Out_FLAGREGISTER,
            MEM1_Writeback_RegAddr => MEM1_MEM2_Out_Writeback_RegAddr,
            MEM1_ImmediateVal => MEM1_MEM2_Out_ImmediateVal,
            MEM1_ALU_RESULT => MEM1_MEM2_Out_ALU_RESULT,
            MEM1_PC => MEM1_MEM2_Out_PC,
            MEM1_PORTOUT => MEM1_MEM2_Out_PORTOUT,
            MEM1_DataMemory_ReadAddr => MEM1_MEM2_OUT_DataMemory_ReadAddr,
            MEM1_DataMemory_WriteData => MEM1_MEM2_OUT_DataMemory_WriteData

        );

    memory2_stage_inst : ENTITY work.Memory2_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            DataMemory_ReadAddr => MEM1_MEM2_OUT_DataMemory_ReadAddr,
            WriteData => MEM1_MEM2_OUT_DataMemory_WriteData,
            Write_enable => MEM1_MEM2_Out_ControlUnitOutput(1),
            SIG_MemRead => MEM1_MEM2_Out_ControlUnitOutput(0),
            SIG_MemToReg => MEM1_MEM2_Out_ControlUnitOutput(3),
            SIG_Branch => MEM1_MEM2_Out_ControlUnitOutput(4),
            SIG_Jump => MEM1_MEM2_Out_ControlUnitOutput(5),
            SIG_ALUop => MEM1_MEM2_Out_ControlUnitOutput(12 DOWNTO 10),
            Zero_flag => MEM1_MEM2_Out_FLAGREGISTER(0),
            Carry_flag => MEM1_MEM2_Out_FLAGREGISTER(2),
            Flag_en => MEM1_MEM2_Out_ControlUnitOutput(9),
            Port_en => MEM1_MEM2_Out_ControlUnitOutput(8),
            PC => ProgramCounter_Current,
            Input_value => in_port,
            Input_enable => MEM1_MEM2_Out_ControlUnitOutput(7) AND MEM1_MEM2_Out_ControlUnitOutput(8),
            Immediate_value => MEM1_MEM2_Out_ImmediateVal,
            ALU_Result => MEM1_MEM2_Out_ALU_RESULT,
            --- Outputs
            PC_out => ProgramCounter_Updated,
            Write_data_RDST => MEM2_WB_IN_WriteBackData,
            PC_Mux_out => Memory_ReturnInterrupt_Out,
            INPUT_PORT_VALUE => Input_port_value
        );

    mem2_wb_buffer_inst : ENTITY work.MEM2_WB_Buffer
        PORT MAP(
            --- Inputs
            clk => clk,
            enable => MEM2_WB_Enable,
            rst => reset,
            WriteBackAddr => MEM1_MEM2_Out_Writeback_RegAddr,
            WriteBackData => MEM2_WB_IN_WriteBackData,
            PORTOUT => Mem1_MEM2_Out_PORTOUT,
            ControlUnitOutput => MEM1_MEM2_Out_ControlUnitOutput,

            --- Outputs
            MEM2_WriteBackAddr => MEM2_WB_Out_WriteBackAddr,
            MEM2_WriteBackData => MEM2_WB_Out_WriteBackData,
            MEM2_PORTOUT => OUTPUT_PORT_VALUE,
            MEM2_ControlUnitOutput => MEM2_WB_OutControlUnitOutput
        );

    output_port_inst : ENTITY work.OUTPUT_PORT
        GENERIC MAP(
            16)
        PORT MAP(
            port_value => OUTPUT_PORT_VALUE,
            enable => (NOT MEM2_WB_OutControlUnitOutput(7) AND MEM2_WB_OutControlUnitOutput(8)),
            out_value => out_port
        );

END ARCHITECTURE;