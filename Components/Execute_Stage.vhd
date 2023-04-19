
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY Execute_Stage IS
    PORT (
        --- Inputs ---
        clk, reset : IN STD_LOGIC;
        ID_EX_ControlSignals : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        ID_EX_RegisterFile_ReadData1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_EX_RegisterFile_ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_EX_RegisterFile_ImmediateVal : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        flagRegisterUpdateCircuit_dataMem : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
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

    ---- ALU output signals
    SIGNAL ALU_Carry : STD_LOGIC;
    SIGNAL ALU_Negative : STD_LOGIC;
    SIGNAL ALU_Zero : STD_LOGIC;

    --- temp
    SIGNAL decoder_sel : STD_LOGIC;
BEGIN
    ---------------------------  ALU input multiplexers  ---------------------------
    decoder_sel <= (NOT ID_EX_ControlSignals(9) AND ID_EX_ControlSignals(8));
    DECODER_ALU_OP1 : ENTITY WORK.Decoder_1x2 GENERIC MAP(16)
        PORT MAP(
            --- Not flag EN AND Port En
            decoder_sel,
            ID_EX_RegisterFile_ReadData1,
            ALU_IN_1,
            OUTPUT_PORT_VALUE
        );
    MUX_ALU_OP2 : ENTITY WORK.MUX
        GENERIC MAP(16)
        PORT MAP(
            in0 => ID_EX_RegisterFile_ReadData2,
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
        EN => ID_EX_ControlSignals(9),
        Q => FlagRegisterTemp
        );
    updateflagregister_inst : ENTITY work.UpdateFlagRegister
        PORT MAP(
            flagEN => ID_EX_ControlSignals(9),
            aluSrc => ID_EX_ControlSignals(2),
            portEN => ID_EX_ControlSignals(8),
            jump => ID_EX_ControlSignals(5),
            memRead => ID_EX_ControlSignals(0),
            aluOp => ID_EX_ControlSignals(12 DOWNTO 10),
            aluCarry => ALU_Carry,
            aluNeg => ALU_Negative,
            aluZero => ALU_Zero,
            dataMem => flagRegisterUpdateCircuit_dataMem(15 DOWNTO 13),
            carryOld => FlagRegisterTemp(2),
            outFlags => FlagRegisterIn
        );
    FlagRegisterValue <= FlagRegisterTemp;
    ---------------------------------------------------------------------------------
    -------------------------------- ALU --------------------------------------------

    ALU : ENTITY WORK.ALU PORT MAP (
        Opcode => ID_EX_ControlSignals(12 DOWNTO 10),
        Operand_1 => ALU_IN_1,
        Operand_2 => ALU_IN_2,
        Output => ALU_Result,
        CARRY => ALU_Carry,
        ZERO => ALU_Zero,
        NEGATIVE => ALU_Negative
        );
    ---------------------------------------------------------------------------------

END ARCHITECTURE;