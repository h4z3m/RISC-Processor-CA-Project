LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY Memory1_Stage IS
    PORT (
        jump : IN STD_LOGIC;
        alu_src : IN STD_LOGIC;
        StackPointer : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Decode_Execute_Out_PC  : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Execute_Mem1_Out_FlagRegister : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        ReadData2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        DataMemory_ReadData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        DataMemory_ReadAddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF Memory1_Stage IS
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
    Data_Memory_ReadData_MUX : ENTITY work.MUX
        GENERIC MAP(
            32
        )
        PORT MAP(
            in0 => ReadData2,
            in1 => Decode_Execute_Out_PC & Execute_Mem1_Out_FlagRegister & "000000000000",
            sel => jump,
            out1 => DataMemory_ReadData
        );

END ARCHITECTURE rtl;