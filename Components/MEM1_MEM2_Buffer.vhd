LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY MEM1_MEM2_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        ControlUnitOutput : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ImmediateVal : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PORTOUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        MEM1_ControlUnitOutput : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        MEM1_FlagRegister : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_PORTOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        -- MEM1_SP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END MEM1_MEM2_Buffer;

ARCHITECTURE rtl OF MEM1_MEM2_Buffer IS

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
    MEM1_MEM2_FF_ControlUnitOutput : D_FF GENERIC MAP(
        13
        ) PORT MAP (ControlUnitOutput, clk, rst, enable, MEM1_ControlUnitOutput
    );

    MEM1_MEM2_FF_FlagRegister : D_FF GENERIC MAP(
        3
        ) PORT MAP (FlagRegister, clk, rst, enable, MEM1_FlagRegister
    );

    MEM1_MEM2_FF_WriteAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (WriteAddr, clk, rst, enable, MEM1_WriteAddr
    );

    MEM1_MEM2_FF_ReadAddr2 : D_FF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr2, clk, rst, enable, MEM1_ReadAddr2
    );

    MEM1_MEM2_FF_ImmediateVal : D_FF GENERIC MAP(
        16
        ) PORT MAP (ImmediateVal, clk, rst, enable, MEM1_ImmediateVal
    );

    MEM1_MEM2_ALU_RESULT : D_FF GENERIC MAP(
        16
        ) PORT MAP (ALU_Result, clk, rst, enable, MEM1_ALU_Result
    );

    MEM1_MEM2_FF_PC : D_FF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, MEM1_PC
    );

    MEM1_MEM2_FF_PORTOUT : D_FF GENERIC MAP(
        16
        ) PORT MAP (PORTOUT, clk, rst, enable, MEM1_PORTOUT
    );

END ARCHITECTURE rtl;