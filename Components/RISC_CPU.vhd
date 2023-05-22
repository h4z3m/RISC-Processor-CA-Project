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
    SIGNAL DecodeStage_PC_Interrupt_buffered : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ExecuteStage_OUTPUT_PORT_VALUE : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ExecuteStage_ALU_Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ExecuteStage_FlagRegisterValue : STD_LOGIC_VECTOR(2 DOWNTO 0);

    SIGNAL Memory1_WritebackRegAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);

    ---- Program counter signals
    SIGNAL ProgramCounter_Updated : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Current : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ProgramCounter_Enable : STD_LOGIC;
    SIGNAL update_pc_carry : STD_LOGIC;
    SIGNAL update_pc_zero : STD_LOGIC;

    ---- Stack pointer signals
    SIGNAL StackPointer_Updated : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL StackPointer_Current : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL StackPointer_Enable : STD_LOGIC;

    ---- Instruction Memory signals
    SIGNAL InstructionMemory_ReadData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL InstructionMemory_adjusted : STD_LOGIC_VECTOR(31 DOWNTO 0);
    ---- Data Memory signals
    SIGNAL DataMemory_WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DataMemory_ReadData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DataMemory_ReadAddr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DataMemory_Mode : STD_LOGIC;

    ---- Register file output signals
    SIGNAL RegisterFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL RegisterFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- Instruction cache mux
    SIGNAL Fetch_Decode_Input_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    ---- Fetch decode buffer signals
    SIGNAL Fetch_Decode_Enable : STD_LOGIC;
    SIGNAL Fetch_Decode_RST : STD_LOGIC;
    SIGNAL Fetch_Decode_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL Fetch_Decode_Interrupt : STD_LOGIC;
    SIGNAL Fetch_Decode_Instruction : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_Opcode : STD_LOGIC_VECTOR(5 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ReadAddr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Fetch_Decode_Instruction_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Fetch_Decode_Out_RESET : STD_LOGIC;
    ---- ID EX buffer signals
    SIGNAL Decode_Execute_Enable : STD_LOGIC;
    SIGNAL Decode_Execute_RST : STD_LOGIC;
    ----OUTPUTS
    SIGNAL Decode_Execute_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL Decode_Execute_Out_RegisterFile_ReadData1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_RegisterFile_ReadData2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_ReadAddr1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Decode_Execute_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Decode_Execute_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL Decode_Execute_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_SP : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Decode_Execute_Out_Interrupt : STD_LOGIC;
    ---- Port signals
    SIGNAL OUTPUT_PORT_VALUE : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --- Execute Memory 1 buffer signals
    SIGNAL Forwarded_ALU_Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    --- Inputs
    SIGNAL Execute_Mem1_Enable : STD_LOGIC;
    SIGNAL Execute_Mem1_RST : STD_LOGIC;

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
    SIGNAL Execute_Mem1_Out_Interrupt : STD_LOGIC;
    SIGNAL Execute_Mem1_Out_PORTOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- M1 M2 buffer signals
    SIGNAL MEM1_MEM2_Enable : STD_LOGIC;
    SIGNAL MEM1_MEM2_RST : STD_LOGIC;
    SIGNAL MEM1_MEM2_Interrupt : STD_LOGIC;
    ----OUTPUTS
    SIGNAL MEM1_MEM2_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_FLAGREGISTER : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL MEM1_MEM2_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- SIGNAL MEM1_MEM2_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_Writeback_RegAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_PORTOUT : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL MEM1_MEM2_Out_DataMemory_ReadAddr : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_DataMemory_WriteData : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_DataMemory_Mode : STD_LOGIC;
    SIGNAL MEM1_MEM2_OUT_Interrupt : STD_LOGIC;

    -- M2 WB buffer signals
    SIGNAL MEM2_WB_Enable : STD_LOGIC;
    SIGNAL MEM2_WB_RST : STD_LOGIC;
    SIGNAL MEM2_WB_IN_WriteBackAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_IN_WriteBackData : STD_LOGIC_VECTOR(15 DOWNTO 0);
    ----OUTPUTS
    SIGNAL MEM2_WB_Out_WriteBackAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_WriteBackData : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM2_WB_OutControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL Memory_ReturnInterrupt_Out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DataMemory_Return_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL DataMemory_Return_FlagRegister : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MUX_BEFORE_PC_NORMAL : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MUX_BEFORE_MEMORY_OUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MUX_BEFORE_PC_OUT_DATA_MEMORY : STD_LOGIC_VECTOR(15 DOWNTO 0);

    SIGNAL FLUSH_SIGNAL : STD_LOGIC;
    SIGNAL LOADUSECASE_STALL_SIGNAL : STD_LOGIC;
    SIGNAL MEMORY_STALL_SIGNAL : STD_LOGIC;
BEGIN

    ProgramCounter_Enable <= '1';
    --=================== HDUs ====================================
    loadusecase_hdu_instance : ENTITY work.LoadUseCase_HDU
        GENERIC MAP(
            stall_cycles => 3
        )
        PORT MAP(
            clk => clk,
            rst => reset,
            Jump => DecodeStage_ControlSignals(5),
            IF_ID_Rs => Fetch_Decode_Instruction_ReadAddr1,
            IF_ID_Rt => Fetch_Decode_Instruction_ReadAddr2,

            ID_EX_Rs => Decode_Execute_Out_ReadAddr1,
            ID_EX_Rt => Decode_Execute_Out_ReadAddr2,

            ID_EX_MemRead => Decode_Execute_Out_ControlUnitOutput(0),
            ID_EX_RegWrite => Decode_Execute_Out_ControlUnitOutput(7),
            ID_EX_PortEn => Decode_Execute_Out_ControlUnitOutput(8),
            ID_EX_ALUsrc => Decode_Execute_Out_ControlUnitOutput(2),
            STALL_SIGNAL => LOADUSECASE_STALL_SIGNAL
        );

    structural_hdu_inst : ENTITY work.Structural_HDU
        PORT MAP(
            clk => clk,
            memRead_ID_EX => Decode_Execute_Out_ControlUnitOutput(0),
            memWrite_ID_EX => Decode_Execute_Out_ControlUnitOutput(1),
            memRead_EX_M1 => Execute_Mem1_Out_ControlUnitOutput(0),
            memWrite_EX_M1 => Execute_Mem1_Out_ControlUnitOutput(1),
            stall_condition => MEMORY_STALL_SIGNAL
        );
    --=============================================================

    -------------------- Buffer reset signals -------------------
    FLUSH_SIGNAL <= reset OR
    (MEM1_MEM2_Out_ControlUnitOutput(5) AND MEM1_MEM2_Out_ControlUnitOutput(0));
    Fetch_Decode_RST <= FLUSH_SIGNAL;
    Decode_Execute_RST <= FLUSH_SIGNAL;
    Execute_Mem1_RST <= FLUSH_SIGNAL;
    MEM1_MEM2_RST <= '0';
    MEM2_WB_RST <= reset;
    --=============================================================

    -------------------- Buffer enable signals -------------------
    Fetch_Decode_Enable <= MEMORY_STALL_SIGNAL AND LOADUSECASE_STALL_SIGNAL;
    Decode_Execute_Enable <= MEMORY_STALL_SIGNAL;
    Execute_Mem1_Enable <= MEMORY_STALL_SIGNAL;
    MEM1_MEM2_Enable <= '1';
    MEM2_WB_Enable <= '1';
    --=============================================================

    mux_inst : ENTITY work.MUX
        GENERIC MAP(
            n => 16
        )
        PORT MAP(
            in0 => ProgramCounter_Updated,
            in1 => InstructionMemory_ReadData(31 DOWNTO 16),
            sel => reset OR interrupt,
            out1 => MUX_BEFORE_PC_NORMAL
        );

    mux_before_pc : ENTITY work.MUX
        GENERIC MAP(
            n => 16
        )
        PORT MAP(
            in0 => MUX_BEFORE_PC_NORMAL,
            in1 => DataMemory_Return_PC,
            sel => MEM1_MEM2_Out_ControlUnitOutput(5) AND MEM1_MEM2_Out_ControlUnitOutput(0),
            out1 => MUX_BEFORE_PC_OUT_DATA_MEMORY
        );
    ProgramCounter : ENTITY work.D_FF GENERIC MAP (
        16
        ) PORT MAP (
        MUX_BEFORE_PC_OUT_DATA_MEMORY,
        clk,
        '0',
        ProgramCounter_Enable,
        ProgramCounter_Current
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
            out1 => MUX_BEFORE_MEMORY_OUT
        );
    StackPointer : ENTITY work.D_FF
        GENERIC MAP(
            16)
        PORT MAP(
            D => StackPointer_Updated,
            CLK => CLK,
            RST => '0',
            EN => StackPointer_Enable,
            Q => StackPointer_Current
        );
    Instruction_Cache : ENTITY work.addressable_memory_big_endian
        GENERIC MAP(
            WORD_SIZE => 16,
            MEM_SIZE => 1024
        )
        PORT MAP(
            clk => clk,
            reset => '0',
            write_en => '0',
            mode => '1',
            word_addr => MUX_BEFORE_MEMORY_OUT(9 DOWNTO 0),
            data_in => (OTHERS => '0'),
            data_out => InstructionMemory_ReadData
        );

    instruction_width_select_inst : ENTITY work.Instruction_width_select
        PORT MAP(
            Instruction => InstructionMemory_ReadData,
            types => InstructionMemory_ReadData(31 DOWNTO 30),
            Instruction_out => InstructionMemory_adjusted
        );
    inst_cache_or_interrupt_mux : ENTITY work.MUX
        GENERIC MAP(
            n => 32
        )
        PORT MAP(
            in0 => InstructionMemory_adjusted,
            in1 => (OTHERS => '0'),
            sel => interrupt,
            out1 => Fetch_Decode_Input_Instruction
        );

    --============================== Fetch decode buffer ==================================
    Fetch_Decode_Buffer : ENTITY work.IF_ID_Buffer PORT MAP (
        --- Inputs
        clk => clk,
        interrupt => interrupt,
        enable => Fetch_Decode_Enable,
        rst => Fetch_Decode_RST,
        PC_RST => reset,
        Instruction => Fetch_Decode_Input_Instruction,
        PC => ProgramCounter_Current,
        --- Outputs
        IF_PC_RST => Fetch_Decode_Out_RESET,
        IF_PC => Fetch_Decode_PC,
        IF_Interrupt => Fetch_Decode_Interrupt,
        IF_Instruction => Fetch_Decode_Instruction,
        IF_Instruction_Opcode => Fetch_Decode_Instruction_Opcode,
        IF_Instruction_ReadAddr1 => Fetch_Decode_Instruction_ReadAddr1,
        IF_Instruction_ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
        IF_Instruction_WriteAddr => Fetch_Decode_Instruction_WriteAddr,
        IF_Instruction_ImmediateVal => Fetch_Decode_Instruction_ImmediateVal
        );
    --============================== Decode stage ==================================

    decode_stage_inst : ENTITY work.Decode_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            reset => reset,
            update_pc_carry => update_pc_carry,
            update_pc_zero => update_pc_zero,
            PC_Reset => Fetch_Decode_Out_RESET,
            IF_ID_PC => Fetch_Decode_PC,
            interrupt => interrupt,
            interrupt_buffered => Fetch_Decode_Interrupt,
            External_Instruction_type => InstructionMemory_adjusted(31 DOWNTO 30),
            PC => ProgramCounter_Current,
            LoadUseCase_Stall => LOADUSECASE_STALL_SIGNAL,
            StructuralHazard_Stall => MEMORY_STALL_SIGNAL,
            IF_ID_Instruction => Fetch_Decode_Instruction,
            IF_ID_ReadAddr1 => Fetch_Decode_Instruction_ReadAddr1,
            IF_ID_ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
            EX_M1_RegWrite => Execute_Mem1_Out_ControlUnitOutput(7),
            EX_M1_RD => Execute_Mem1_Out_WriteAddr,
            EX_M1_RT => Execute_Mem1_Out_ReadAddr2,
            EX_M1_RegDst => Execute_Mem1_Out_ControlUnitOutput(6),
            ID_EX_ReadAddr2 => Decode_Execute_Out_ReadAddr2,
            ID_EX_WriteAddr => Decode_Execute_Out_WriteAddr,
            ID_EX_RegDst => Decode_Execute_Out_ControlUnitOutput(6),
            ID_EX_RegWrite => Decode_Execute_Out_ControlUnitOutput(7),

            M1_immediate => Execute_Mem1_Out_ImmediateVal,
            Execute_ALU_Result => ExecuteStage_ALU_Result,

            M1_M2_RegWrite => MEM1_MEM2_Out_ControlUnitOutput(7),
            MEM1_MEM2_WB_Addr => MEM1_MEM2_Out_Writeback_RegAddr,
            MEM1_MEM2_WB_Data => MEM2_WB_IN_WriteBackData,

            MEM2_WB_RegisterFile_WriteData => MEM2_WB_Out_WriteBackData,
            MEM2_WB_RegisterFile_WriteAddr => MEM2_WB_Out_WriteBackAddr,
            RegFile_RegWrite_Enable => MEM2_WB_OutControlUnitOutput(7),
            Zero_Flag => ExecuteStage_FlagRegisterValue(0),
            Carry_Flag => ExecuteStage_FlagRegisterValue(2),
            --- Outputs
            PC_Out => ProgramCounter_Updated,
            PC_Interrupt_Out => DecodeStage_PC_Interrupt_buffered,
            IF_ID_ControlSignals => DecodeStage_ControlSignals,
            RegFile_ReadData1 => DecodeStage_RegFile_ReadData1,
            RegFile_ReadData2 => DecodeStage_RegFile_ReadData2
        );

    --============================== Decode Execute buffer ==================================

    Decode_Execute_Buffer : ENTITY work.ID_EX_Buffer PORT MAP (
        --- Inputs    
        enable => Decode_Execute_Enable,
        clk => clk,
        rst => Decode_Execute_RST,
        interrupt => Fetch_Decode_Interrupt,
        ControlUnitOutput => DecodeStage_ControlSignals,
        RegisterFile_ReadData1 => DecodeStage_RegFile_ReadData1,
        RegisterFile_ReadData2 => DecodeStage_RegFile_ReadData2,
        WriteAddr => Fetch_Decode_Instruction_WriteAddr,
        ReadAddr1 => Fetch_Decode_Instruction_ReadAddr1,
        ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
        ImmediateVal => Fetch_Decode_Instruction_ImmediateVal,
        PC => DecodeStage_PC_Interrupt_buffered,

        --- Outputs
        ID_ControlUnitOutput => Decode_Execute_Out_ControlUnitOutput,
        ID_RegisterFile_ReadData1 => Decode_Execute_Out_RegisterFile_ReadData1,
        ID_RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
        ID_WriteAddr => Decode_Execute_Out_WriteAddr,
        ID_ReadAddr1 => Decode_Execute_Out_ReadAddr1,
        ID_ReadAddr2 => Decode_Execute_Out_ReadAddr2,
        ID_ImmediateVal => Decode_Execute_Out_ImmediateVal,
        ID_PC => Decode_Execute_Out_PC,
        ID_Interrupt => Decode_Execute_Out_Interrupt
        );
    --============================== Execute stage ==================================

    execute_stage_inst : ENTITY work.Execute_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            reset => reset,

            ID_EX_ControlSignals => Decode_Execute_Out_ControlUnitOutput,
            ID_EX_RegisterFile_ReadAddr1 => Decode_Execute_Out_ReadAddr1,
            ID_EX_RegisterFile_ReadAddr2 => Decode_Execute_Out_ReadAddr2,
            ID_EX_RegisterFile_ReadData1 => Decode_Execute_Out_RegisterFile_ReadData1,
            ID_EX_RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
            ID_EX_RegisterFile_ImmediateVal => Decode_Execute_Out_ImmediateVal,
            Forwarded_ALU_Result => Forwarded_ALU_Result,
            EX_MEM1_Out_RegWrite => Execute_Mem1_Out_ControlUnitOutput(7),

            MEM1_Addr_MUX_Out => Memory1_WritebackRegAddr,
            MEM1_MEM2_Out_MemRead => MEM1_MEM2_Out_ControlUnitOutput(0),
            MEM1_MEM2_Out_Jump => MEM1_MEM2_Out_ControlUnitOutput(5),
            MEM1_Mem2_Out_RegWrite => MEM1_MEM2_Out_ControlUnitOutput(7),

            MEM2_Out_WB_Data => MEM2_WB_IN_WriteBackData,
            MEM2_Out_WB_Addr => MEM1_MEM2_Out_Writeback_RegAddr,
            flagRegisterUpdateCircuit_dataMem => DataMemory_Return_FlagRegister,
            flag_stall_signal => LOADUSECASE_STALL_SIGNAL,
            MEM2_WB_Out_RegWrite => MEM2_WB_OutControlUnitOutput(7),
            MEM2_WB_Out_WB_Data => MEM2_WB_Out_WriteBackData,
            MEM2_WB_Out_WB_Addr => MEM2_WB_Out_WriteBackAddr,
            decode_branch => DecodeStage_ControlSignals(4),
            --- Outputs
            OUTPUT_PORT_VALUE => ExecuteStage_OUTPUT_PORT_VALUE,
            ALU_Result => ExecuteStage_ALU_Result,
            FlagRegisterValue => ExecuteStage_FlagRegisterValue,
            update_pc_carry => update_pc_carry,
            update_pc_zero => update_pc_zero
        );
    --============================== Execute Memory1 buffer ==================================

    ex_mem1_buffer_inst : ENTITY work.EX_MEM1_Buffer
        PORT MAP(
            --- Inputs
            clk => clk,
            enable => Execute_Mem1_Enable,
            rst => Execute_Mem1_RST,
            interrupt => Decode_Execute_Out_Interrupt,
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
            EX_PORTOUT => Execute_Mem1_Out_PORTOUT,
            EX_Interrupt => Execute_Mem1_Out_Interrupt
        );

    --============================== Memory1 stage ==================================

    memory1_stage_inst : ENTITY work.Memory1_Stage
        PORT MAP(
            --- Inputs
            reset => reset,
            buffered_interrupt => Execute_Mem1_Out_Interrupt,
            ControlSignals => Execute_Mem1_Out_ControlUnitOutput,
            StackPointer => StackPointer_Current,
            ALU_Result => Execute_Mem1_Out_ALU_Result,
            PC => MEM1_MEM2_Out_PC,
            Execute_Mem1_Out_FlagRegister => Execute_Mem1_Out_FlagRegister,
            ReadData2 => Execute_Mem1_Out_RegisterFile_ReadData2,
            Write_back_address_mux_2x1_in0 => Execute_Mem1_Out_WriteAddr,
            Write_back_address_mux_2x1_in1 => Execute_Mem1_Out_ReadAddr2,
            ImmediateValue => Execute_Mem1_Out_ImmediateVal,
            --- Outputs
            DataMemory_WriteData => DataMemory_WriteData,
            DataMemory_ReadAddr => DataMemory_ReadAddr,
            DataMemory_Mode => DataMemory_Mode,
            StackPointer_Updated => StackPointer_Updated,
            StackPointer_Enable => StackPointer_Enable,
            Write_back_address_mux_2x1_out => Memory1_WritebackRegAddr,
            Forwarded_ALU_Result => Forwarded_ALU_Result
        );

    --============================== Memory1 Memory2 buffer ==================================
    mem1_mem2_buffer_inst : ENTITY work.MEM1_MEM2_Buffer
        PORT MAP(
            -- Inputs

            clk => clk,
            enable => MEM1_MEM2_Enable,
            rst => MEM1_MEM2_RST,
            interrupt => Execute_Mem1_Out_Interrupt,
            ControlUnitOutput => Execute_Mem1_Out_ControlUnitOutput,
            FlagRegister => Execute_Mem1_Out_FlagRegister,
            Writeback_RegAddr => Memory1_WritebackRegAddr,
            ImmediateVal => Execute_Mem1_Out_ImmediateVal,
            ALU_Result => Execute_Mem1_Out_ALU_Result,
            PC => Execute_Mem1_Out_PC,
            PORTOUT => Execute_Mem1_Out_PORTOUT,
            DataMemory_ReadAddr => DataMemory_ReadAddr,
            DataMemory_WriteData => DataMemory_WriteData,
            DataMemory_Mode => DataMemory_Mode,
            -- Ouputs
            MEM1_ControlUnitOutput => MEM1_MEM2_Out_ControlUnitOutput,
            MEM1_FLAGREGISTER => MEM1_MEM2_Out_FLAGREGISTER,
            MEM1_Writeback_RegAddr => MEM1_MEM2_Out_Writeback_RegAddr,
            MEM1_ImmediateVal => MEM1_MEM2_Out_ImmediateVal,
            MEM1_ALU_RESULT => MEM1_MEM2_Out_ALU_RESULT,
            MEM1_PC => MEM1_MEM2_Out_PC,
            MEM1_PORTOUT => MEM1_MEM2_Out_PORTOUT,
            MEM1_DataMemory_ReadAddr => MEM1_MEM2_OUT_DataMemory_ReadAddr,
            MEM1_DataMemory_WriteData => MEM1_MEM2_Out_DataMemory_WriteData,
            MEM1_DataMemory_Mode => MEM1_MEM2_Out_DataMemory_Mode,
            MEM1_Interrupt => MEM1_MEM2_OUT_Interrupt
        );

    --============================== Memory2 stage ==================================
    memory2_stage_inst : ENTITY work.Memory2_Stage
        PORT MAP(
            --- Inputs
            clk => clk,
            DataMemory_ReadAddr => MEM1_MEM2_OUT_DataMemory_ReadAddr,
            DataMemory_Mode => MEM1_MEM2_OUT_DataMemory_Mode,
            WriteData => MEM1_MEM2_Out_DataMemory_WriteData,
            Write_enable => MEM1_MEM2_Out_ControlUnitOutput(1) OR MEM1_MEM2_OUT_Interrupt,
            SIG_MemRead => MEM1_MEM2_Out_ControlUnitOutput(0),
            SIG_MemToReg => MEM1_MEM2_Out_ControlUnitOutput(3),
            SIG_Jump => MEM1_MEM2_Out_ControlUnitOutput(5),
            Flag_en => MEM1_MEM2_Out_ControlUnitOutput(9),
            Port_en => MEM1_MEM2_Out_ControlUnitOutput(8),
            RegWrite => MEM1_MEM2_Out_ControlUnitOutput(7),
            RegDst => MEM1_MEM2_Out_ControlUnitOutput(6),
            -- PC => ProgramCounter_Current,
            Input_value => in_port,
            Input_enable => MEM1_MEM2_Out_ControlUnitOutput(7) AND MEM1_MEM2_Out_ControlUnitOutput(8),
            Immediate_value => MEM1_MEM2_Out_ImmediateVal,
            ALU_Result => MEM1_MEM2_Out_ALU_RESULT,

            --- Outputs
            -- PC_out => ProgramCounter_Updated,
            Write_data_RDST => MEM2_WB_IN_WriteBackData,
            INPUT_PORT_VALUE => Input_port_value,
            DataMemory_Return_PC_Out => DataMemory_Return_PC,
            DataMemory_Return_FlagRegister_Out => DataMemory_Return_FlagRegister
        );

    --============================== Memory2 Writeback buffer ==================================
    mem2_wb_buffer_inst : ENTITY work.MEM2_WB_Buffer
        PORT MAP(
            --- Inputs
            clk => clk,
            enable => MEM2_WB_Enable,
            rst => MEM2_WB_RST,
            WriteBackAddr => MEM1_MEM2_Out_Writeback_RegAddr,
            WriteBackData => MEM2_WB_IN_WriteBackData,
            PORTOUT => MEM1_MEM2_Out_PORTOUT,
            ControlUnitOutput => MEM1_MEM2_Out_ControlUnitOutput,

            --- Outputs
            MEM2_WriteBackAddr => MEM2_WB_Out_WriteBackAddr,
            MEM2_WriteBackData => MEM2_WB_Out_WriteBackData,
            MEM2_PORTOUT => OUTPUT_PORT_VALUE,
            MEM2_ControlUnitOutput => MEM2_WB_OutControlUnitOutput
        );
    --============================== Writeback stage ==================================
    output_port_inst : ENTITY work.OUTPUT_PORT
        GENERIC MAP(
            16)
        PORT MAP(
            port_value => OUTPUT_PORT_VALUE,
            enable => (NOT MEM2_WB_OutControlUnitOutput(7) AND MEM2_WB_OutControlUnitOutput(8) AND NOT MEM2_WB_OutControlUnitOutput(2)),
            out_value => out_port
        );

END ARCHITECTURE;