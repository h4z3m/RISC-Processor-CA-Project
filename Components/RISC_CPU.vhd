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
        -- d : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- d1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
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
    ---- 1 -> MemWrite
    ---- 2 -> ALUsrc
    ---- 3 -> MemToReg
    ---- 4 -> Branch
    ---- 5 -> Jump
    ---- 6 -> RegDst
    ---- 7 -> RegWrite
    ---- 8 -> PortEN
    ---- 9 -> FlagEN
    ---- 12-10 -> ALUop
    SIGNAL Control_Signals : STD_LOGIC_VECTOR(12 DOWNTO 0);

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

    ---- ALU output signals
    SIGNAL ALU_Result : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_Carry : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_Negative : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_Zero : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --- Flag register signals
    SIGNAL FlagRegisterIn : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL FlagRegisterCurrent : STD_LOGIC_VECTOR(2 DOWNTO 0);

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

    ----ALu SIGNALS
    SIGNAL ALU_IN_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_IN_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

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

    ---- M1 M2 buffer signals
    SIGNAL MEM1_MEM2_Enable : STD_LOGIC;

    ----OUTPUTS
    SIGNAL MEM1_MEM2_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_FLAGREGISTER : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM1_MEM2_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);

    ---- M2 WB buffer signals
    SIGNAL MEM1_MEM2_Enable : STD_LOGIC;

    ----OUTPUTS
    SIGNAL MEM2_WB_Out_ControlUnitOutput : STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL MEM2_WB_Out_FLAGREGISTER : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_ReadAddr2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_WriteAddr : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL MEM2_WB_Out_ImmediateVal : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM2_WB_Out_ALU_RESULT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MEM2_WB_Out_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN
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

    -- SignExtended_Immediate <= "0000000000000000" & IF_Instruction_ImmediateVal;

    Decode_Execute_Buffer : ENTITY work.ID_EX_Buffer PORT MAP (
        enable => Decode_Execute_Enable,
        clk => clk,
        rst => reset,

        ControlUnitOutput => Control_Signals,
        RegisterFile_ReadData1 => RegisterFile_ReadData1,
        RegisterFile_ReadData2 => RegisterFile_ReadData2,
        WriteAddr => Fetch_Decode_Instruction_WriteAddr,
        ReadAddr2 => Fetch_Decode_Instruction_ReadAddr2,
        ImmediateVal => IF_Instruction_ImmediateVal,
        PC => Fetch_Decode_PC,
        --SP => --- from SP update circin this stage,

        ID_ControlUnitOutput => Decode_Execute_Out_ControlUnitOutput,
        ID_RegisterFile_ReadData1 => Decode_Execute_Out_RegisterFile_ReadData1,
        ID_RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
        ID_WriteAddr => Decode_Execute_Out_WriteAddr,
        ID_ReadAddr2 => Decode_Execute_Out_ReadAddr2,
        ID_ImmediateVal => Decode_Execute_Out_ImmediateVal,
        ID_PC => Decode_Execute_Out_PC,
        ID_SP => Decode_Execute_Out_SP
        );

    ex_mem1_buffer_inst : ENTITY work.EX_MEM1_Buffer
        PORT MAP(
            clk => clk,
            enable => Execute_Mem1_Enable,
            rst => reset,
            ControlUnitOutput => Decode_Execute_Out_ControlUnitOutput,
            FlagRegister => FlagRegisterCurrent,
            RegisterFile_ReadData2 => Decode_Execute_Out_RegisterFile_ReadData2,
            WriteAddr => Decode_Execute_Out_WriteAddr,
            ReadAddr2 => Decode_Execute_Out_ReadAddr2,
            ImmediateVal => Decode_Execute_Out_ImmediateVal,
            ALU_Result => ALU_Result,
            PC => Decode_Execute_Out_PC,
            SP => Decode_Execute_Out_SP,

            EX_ControlUnitOutput => Execute_Mem1_Out_ControlUnitOutput,
            EX_FlagRegister => Execute_Mem1_Out_FlagRegister,
            EX_RegisterFile_ReadData2 => Execute_Mem1_Out_RegisterFile_ReadData2,
            EX_WriteAddr => Execute_Mem1_Out_WriteAddr,
            EX_ReadAddr2 => Execute_Mem1_Out_ReadAddr2,
            EX_ImmediateVal => Execute_Mem1_Out_ImmediateVal,
            EX_ALU_Result => Execute_Mem1_Out_ALU_Result,
            EX_PC => Execute_Mem1_Out_PC,
            EX_SP => Execute_Mem1_Out_SP
        );
    ----------------------- Pipeline buffers -----------------------

    ------------------    
    ProgramCounter_Enable <= '1';
    ------------------    
    ---/ Before Fetch /---------------------------------------------------
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
    ---/ Fetch /---------------------------------------------------
    RegFile : ENTITY WORK.RegisterFile GENERIC MAP (
        16,
        8
        ) PORT MAP (clk => clk,
        CLK => clk, WR_ENABLE => SIG_RegWrite,
        WRITE_PORT => --- from write back
        ,
        WRITE_ADDR => --- from write back
        ,
        READ_ADDR_1 => Fetch_Decode_Instruction_ReadAddr1,
        READ_PORT_1 => Decode_Execute_In_RegisterFile_ReadData1,
        READ_ADDR_2 => Fetch_Decode_Instruction_ReadAddr2,
        READ_PORT_2 => Decode_Execute_In_RegisterFile_ReadData2,
        );
    ControlUnit : ENTITY WORK.ControlUnit PORT MAP (
        Instruction => Fetch_Decode_Instruction,
        SIG_MemRead => Control_Signals(0),
        SIG_MemWrite => Control_Signals(1),
        SIG_ALUsrc => Control_Signals(2),
        SIG_MemToReg => Control_Signals(3),
        SIG_Branch => Control_Signals(4),
        SIG_Jump => Control_Signals(5),
        SIG_RegDst => Control_Signals(6),
        SIG_RegWrite => Control_Signals(7),
        SIG_PortEN => Control_Signals(8),
        SIG_FlagEN => Control_Signals(9),
        SIG_ALUop => Control_Signals(12 DOWNTO 10)
        );
    -- UpdateProgramCounter : ENTITY WORK.UpdatePCcircuit PORT MAP (
    --     rdst
    --     PC_Return_Stack
    --     PC
    --     Flag_en
    --     SIG_MemWrite => SIG_MemWrite;
    --     SIG_MemRead => SIG_MemRead;
    --     SIG_Branch => SIG_Branch;
    --     SIG_Jump => SIG_Jump;
    --     SIG_AluOP0 => SIG_ALUop(0);
    --     Zero_flag
    --     Carry_flag
    --     PC_out
    --     );
    MUX_ALU_OP2 : ENTITY WORK.MUX
        GENERIC MAP(16)
        PORT MAP(
            in0 => Decode_Execute_Out_RegisterFile_ReadData2,
            in1 => Decode_Execute_Out_ImmediateVal,
            sel => Decode_Execute_Out_ControlUnitOutput(2),
            out1 => ALU_IN_2
        );
    ---- Control unit Signals
    ---- 0 -> MemRead,
    ---- 1 -> MemWrite
    ---- 2 -> ALUsrc
    ---- 3 -> MemToReg
    ---- 4 -> Branch
    ---- 5 -> Jump
    ---- 6 -> RegDst
    ---- 7 -> RegWrite
    ---- 8 -> PortEN
    ---- 9 -> FlagEN
    ---- 12-10 -> ALUop
    updateflagregister_inst : ENTITY work.UpdateFlagRegister
        PORT MAP(
            flagEN => Decode_Execute_Out_ControlUnitOutput(9),
            aluSrc => Decode_Execute_Out_ControlUnitOutput(2),
            portEN => Decode_Execute_Out_ControlUnitOutput(8),
            jump => Decode_Execute_Out_ControlUnitOutput(5),
            memRead => Decode_Execute_Out_ControlUnitOutput(0),
            aluOp => Decode_Execute_Out_ControlUnitOutput(12 DOWNTO 10),
            aluCarry => ALU_Carry,
            aluNeg => ALU_Negative,
            aluZero => ALU_Zero,
            dataMem => --- from data memory decoder,
            carryOld => FlagRegisterCurrent,
            outFlags => FlagRegisterIn
        );
    FlagRegister : ENTITY WORK.D_FF GENERIC MAP (
        3
        ) PORT MAP (
        D => FlagRegisterIn,
        CLK => clk,
        RST => reset,
        EN => Decode_Execute_Out_ControlUnitOutput(9),
        Q => FlagRegisterCurrent
        );

    DECODER_ALU_OP1 : ENTITY WORK.Decoder_1x2 GENERIC MAP(16)
        PORT MAP(
            NOT Decode_Execute_Out_ControlUnitOutput(9) AND Decode_Execute_Out_ControlUnitOutput(8),
            Decode_Execute_Out_RegisterFile_ReadData1, ALU_IN_1, OUTPUT_PORT_VALUE
        );
    input_port_inst : ENTITY work.INPUT_PORT
        GENERIC MAP(
            16
        )
        PORT MAP(
            in_value => in_value,
            enable => enable,
            port_value => port_value
        );
    output_port_inst : ENTITY work.OUTPUT_PORT
        GENERIC MAP(
            16)
        PORT MAP(
            port_value => OUTPUT_PORT_VALUE,
            enable => enable,
            out_value => out_value
        );
    ALU : ENTITY WORK.ALU PORT MAP (
        Opcode => ID_ControlUnitOutput(12 DOWNTO 10),
        Operand_1 => ALU_IN_1,
        Operand_2 => ALU_IN_2
        , Output => ALU_Result,
        CARRY => ALU_Carry,
        ZERO => ALU_Zero,
        NEGATIVE => ALU_Negative
        );
    Data_Memory_ReadAddr_MUX : ENTITY work.MUX
        GENERIC MAP(
            16
        )
        PORT MAP(
            in0 => Execute_Mem1_Out_SP,
            in1 => Execute_Mem1_Out_ALU_Result,
            sel => Execute_Mem1_Out_ControlUnitOutput(2),
            out1 => DataMemory_ReadAddr
        );
    Data_Memory_ReadAddr_MUX : ENTITY work.MUX
        GENERIC MAP(
            16
        )
        PORT MAP(
            in0 => Execute_Mem1_Out_RegisterFile_ReadData2,
            in1 => Decode_Execute_Out_PC & Execute_Mem1_Out_FlagRegister & "000000000000",
            sel => Execute_Mem1_Out_ControlUnitOutput(5),
            out1 => DataMemory_ReadData
        );

    Data_Memory : ENTITY work.Memory GENERIC MAP (
        32, 1024
        ) PORT MAP (
        ReadAddr => DataMemory_ReadAddr,
        ReadData => DataMemory_ReadData,
        we => -- from mux,
        clk => clk,
        WriteData => (OTHERS => '0')
        );
END ARCHITECTURE;