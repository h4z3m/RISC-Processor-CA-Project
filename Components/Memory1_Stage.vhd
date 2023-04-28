LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY Memory1_Stage IS
    PORT (
        -- Inputs
        jump : IN STD_LOGIC;
        alu_src : IN STD_LOGIC;
        StackPointer : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Decode_Execute_Out_PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Execute_Mem1_Out_FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        --Write_back_address_mux_2x1
        Write_back_address_mux_2x1_in0 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Write_back_address_mux_2x1_in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIG_RegDst : IN STD_LOGIC;

        -- Outputs
        DataMemory_WriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        DataMemory_ReadAddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Write_back_address_mux_2x1_out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)

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
            sel => alu_src,
            out1 => DataMemory_ReadAddr
        );

    temp_mux_in1 <= Decode_Execute_Out_PC & Execute_Mem1_Out_FlagRegister & "0000000000000";
    Data_Memory_WriteData_MUX : ENTITY work.MUX
        GENERIC MAP(
            32
        )
        PORT MAP(
            ----- endianness?
            in0 => "0000000000000000" & ReadData2,
            in1 => temp_mux_in1,
            sel => jump,
            out1 => DataMemory_WriteData
        );
    Write_back_address_mux_2x1 : ENTITY work.MUX GENERIC MAP(3)
        PORT MAP(
            in0 => Write_back_address_mux_2x1_in1,
            in1 => Write_back_address_mux_2x1_in0,
            sel => SIG_RegDst,
            out1 => Write_back_address_mux_2x1_out
        );
END ARCHITECTURE rtl;