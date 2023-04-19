LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY EX_MEM1_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        ControlUnitOutput : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RegisterFile_ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ImmediateVal : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        EX_ControlUnitOutput : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        EX_FlagRegister : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_RegisterFile_ReadData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EX_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        EX_ImmediateVal : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        EX_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EX_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        EX_SP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY EX_MEM1_Buffer;

ARCHITECTURE rtl OF EX_MEM1_Buffer IS

    COMPONENT D_FF IS
        GENERIC (
            N : INTEGER := 16
        );
        PORT (
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            CLK, RST, EN : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    EX_MEM1_FF_ControlUnitOutput : D_FF GENERIC MAP(
        13
        ) PORT MAP (ControlUnitOutput, clk, rst, enable, EX_ControlUnitOutput
    );

    EX_MEM1_FF_FlagRegister : D_FF GENERIC MAP(
        2
        ) PORT MAP (FlagRegister, clk, rst, enable, EX_FlagRegister
    );

    EX_MEM1_FF_RegisterFile_ReadData2 : D_FF GENERIC MAP(
        16
        ) PORT MAP (RegisterFile_ReadData2, clk, rst, enable, EX_RegisterFile_ReadData2
    );

    EX_MEM1_FF_WriteAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (WriteAddr, clk, rst, enable, EX_WriteAddr
    );

    EX_MEM1_FF_ReadAddr2 : D_FF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr2, clk, rst, enable, EX_ReadAddr2
    );

    EX_MEM1_FF_ImmediateVal : D_FF GENERIC MAP(
        32
        ) PORT MAP (ImmediateVal, clk, rst, enable, EX_ImmediateVal
    );

    EX_MEM1_ALU_RESULT : D_FF GENERIC MAP(
        16
        ) PORT MAP (ALU_Result, clk, rst, enable, EX_ALU_Result
    );

    EX_MEM1_FF_PC : D_FF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, EX_PC
    );
    EX_MEM1_FF_SP : D_FF GENERIC MAP(
        16
        ) PORT MAP (SP, clk, rst, enable, EX_SP
    );
END ARCHITECTURE rtl;