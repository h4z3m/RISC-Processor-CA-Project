
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY Execute_Stage IS
    PORT (
        --- Inputs ---
        clk, reset : IN STD_LOGIC;
        ID_EX_ControlSignals : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        ID_EX_RegisterFile_ReadAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RegisterFile_ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RegisterFile_ReadData1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_EX_RegisterFile_ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_EX_RegisterFile_ImmediateVal : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        Forwarded_ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        EX_MEM1_Out_RegWrite : IN STD_LOGIC;

        MEM1_Addr_MUX_Out : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        MEM1_Mem2_Out_RegWrite : IN STD_LOGIC;
        MEM2_WB_Out_RegWrite : IN STD_LOGIC;

        MEM2_Out_WB_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_WB_Out_WB_Data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_Out_WB_Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_WB_Out_WB_Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        MEM1_MEM2_Out_MemRead : IN STD_LOGIC;
        MEM1_MEM2_Out_Jump : IN STD_LOGIC;
        flagRegisterUpdateCircuit_dataMem : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        --- Outputs ---
        OUTPUT_PORT_VALUE : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        FlagRegisterValue : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END ENTITY Execute_Stage;
ARCHITECTURE rtl OF Execute_Stage IS

    ----ALu SIGNALS
    SIGNAL ALU_IN_1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ALU_IN_2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --- Flag register signals
    SIGNAL FlagRegisterIn : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL FlagRegisterTemp : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL flag_enable_out : STD_LOGIC;

    ---- ALU output signals
    SIGNAL ALU_Carry : STD_LOGIC;
    SIGNAL ALU_Negative : STD_LOGIC;
    SIGNAL ALU_Zero : STD_LOGIC;

    ---- Forwarding unit signals
    SIGNAL OUT_OF_MUX_OP1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL OUT_OF_MUX_OP2 : STD_LOGIC_VECTOR(15 DOWNTO 0);

BEGIN
    -- ---------------------------  ALU input multiplexers  ---------------------------
    -- decoder_sel <= (NOT ID_EX_ControlSignals(9) AND ID_EX_ControlSignals(8));
    -- DECODER_ALU_OP1 : ENTITY WORK.Decoder_1x2 GENERIC MAP(16)
    --     PORT MAP(
    --         --- Not flag EN AND Port En
    --         decoder_sel,
    --         ID_EX_RegisterFile_ReadData1,
    --         ALU_IN_1,
    --         OUTPUT_PORT_VALUE
    --     );
    ALU_IN_1 <= ID_EX_RegisterFile_ReadData1;
    OUTPUT_PORT_VALUE <= OUT_OF_MUX_OP1;
    MUX_ALU_OP2 : ENTITY WORK.MUX
        GENERIC MAP(16)
        PORT MAP(
            in0 => OUT_OF_MUX_OP2,
            in1 => ID_EX_RegisterFile_ImmediateVal,
            sel => ID_EX_ControlSignals(2),
            out1 => ALU_IN_2
        );
    ---------------------------------------------------------------------------------
    ---------------------------  Flag Register  -------------------------------------

    FlagRegister : ENTITY WORK.D_FF GENERIC MAP (
        3
        ) PORT MAP (
        D => FlagRegisterIn,
        CLK => clk,
        RST => reset,
        EN => flag_enable_out,
        Q => FlagRegisterTemp
        );
    updateflagregister_inst : ENTITY work.UpdateFlagRegister
        PORT MAP(
            flagEN => ID_EX_ControlSignals(9),
            aluSrc => ID_EX_ControlSignals(2),
            jump => ID_EX_ControlSignals(5),
            memRead => ID_EX_ControlSignals(0),
            jump_mem2_stage => MEM1_MEM2_Out_Jump,
            memRead_mem2_stage => MEM1_MEM2_Out_MemRead,
            aluOp => ID_EX_ControlSignals(12 DOWNTO 10),
            aluCarry => ALU_Carry,
            aluNeg => ALU_Negative,
            aluZero => ALU_Zero,
            dataMem_return => flagRegisterUpdateCircuit_dataMem,
            carryOld => FlagRegisterTemp(2),
            carry_flag_enable => flag_enable_out,
            outFlags => FlagRegisterIn
        );
    FlagRegisterValue <= FlagRegisterTemp;
    ---------------------------------------------------------------------------------
    -------------------------------- ALU --------------------------------------------

    ALU : ENTITY WORK.ALU PORT MAP (
        Opcode => ID_EX_ControlSignals(12 DOWNTO 10),
        Operand_1 => OUT_OF_MUX_OP1,
        Operand_2 => ALU_IN_2,
        Result => ALU_Result,
        CARRY => ALU_Carry,
        ZERO => ALU_Zero,
        NEGATIVE => ALU_Negative
        );
    ---------------------------------------------------------------------------------
    opforwardingunit_inst : ENTITY work.OPForwardingUnit
        PORT MAP(
            -- Inputs
            RS => ID_EX_RegisterFile_ReadAddr1,
            RT => ID_EX_RegisterFile_ReadAddr2,
            Ex_M1_Regw => EX_MEM1_Out_RegWrite,
            M1_M2_Regw => MEM1_Mem2_Out_RegWrite,
            WB_DATA => MEM2_Out_WB_Data,
            ALU_RESULT => Forwarded_ALU_Result,
            OP1 => ALU_IN_1,
            OP2 => ID_EX_RegisterFile_ReadData2,
            WB_ADDRESS => MEM2_Out_WB_Addr,
            OUT_OF_MUX_MEM1 => MEM1_Addr_MUX_Out,

            M2_WB_Regw => MEM2_WB_Out_RegWrite,
            WB_DATA_M2_WB => MEM2_WB_Out_WB_Data,
            WB_ADDRESS_M2_WB => MEM2_WB_Out_WB_Addr,
            -- Outputs
            OUT_OF_MUX_OP1 => OUT_OF_MUX_OP1,
            OUT_OF_MUX_OP2 => OUT_OF_MUX_OP2
        );
END ARCHITECTURE;