LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY Memory1_Stage IS
    PORT (
        -- Inputs
        reset : IN STD_LOGIC;
        buffered_interrupt : IN STD_LOGIC;
        ControlSignals : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        StackPointer : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Execute_Mem1_Out_FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ImmediateValue : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --Write_back_address_mux_2x1
        Write_back_address_mux_2x1_in0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_back_address_mux_2x1_in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Outputs
        DataMemory_WriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        DataMemory_ReadAddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_back_address_mux_2x1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        StackPointer_Updated : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        StackPointer_Enable : OUT STD_LOGIC;
        DataMemory_Mode : OUT STD_LOGIC;
        Forwarded_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF Memory1_Stage IS
    SIGNAL temp_mux_in1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN

    Data_Memory_ReadAddr_MUX : ENTITY work.MUX
        GENERIC MAP(
            16
        )
        PORT MAP(
            in0 => StackPointer,
            in1 => ALU_Result,
            sel => ControlSignals(2),
            out1 => DataMemory_ReadAddr
        );

    temp_mux_in1 <= "0000000000000" & Execute_Mem1_Out_FlagRegister & PC;

    Data_Memory_WriteData_MUX : ENTITY work.MUX
        GENERIC MAP(
            32
        )
        PORT MAP(
            ----- endianness?
            in0 => "0000000000000000" & ReadData2,
            in1 => temp_mux_in1,
            sel => ControlSignals(5) OR buffered_interrupt,
            out1 => DataMemory_WriteData
        );
    Write_back_address_mux_2x1 : ENTITY work.MUX GENERIC MAP(3)
        PORT MAP(
            in0 => Write_back_address_mux_2x1_in1,
            in1 => Write_back_address_mux_2x1_in0,
            sel => ControlSignals(6),
            out1 => Write_back_address_mux_2x1_out
        );

    updatespcircuit_inst : ENTITY work.UpdateSpCircuit
        PORT MAP(
            SP => StackPointer,
            SIG_MemRead => ControlSignals(0),
            SIG_MemWrite => ControlSignals(1),
            SIG_FlagEn => ControlSignals(9),
            Interrupt => buffered_interrupt,
            SIG_ALUsrc => ControlSignals(2),
            reset => reset,
            SP_Modified => StackPointer_Updated,
            SP_Enable => StackPointer_Enable,
            SP_MODE => DataMemory_Mode
        );
    mux_inst : ENTITY work.MUX
        GENERIC MAP(
            n => 16
        )
        PORT MAP(
            in0 => ImmediateValue,
            in1 => ALU_Result,
            sel => ControlSignals(6),
            out1 => Forwarded_ALU_Result
        );
END ARCHITECTURE rtl;