LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY MEM2_WB_Buffer IS
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
        -- SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        MEM2_ControlUnitOutput : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        MEM2_FlagRegister : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        -- MEM2_SP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY MEM2_WB_Buffer;

ARCHITECTURE rtl OF MEM2_WB_Buffer IS

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
    MEM2_WB_FF_ControlUnitOutput : D_FF GENERIC MAP(
        13
        ) PORT MAP (ControlUnitOutput, clk, rst, enable, MEM2_ControlUnitOutput
    );

    MEM2_WB_FF_FlagRegister : D_FF GENERIC MAP(
        3
        ) PORT MAP (FlagRegister, clk, rst, enable, MEM2_FlagRegister
    );

    MEM2_WB_FF_WriteAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (WriteAddr, clk, rst, enable, MEM2_WriteAddr
    );

    MEM2_WB_FF_ReadAddr2 : D_FF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr2, clk, rst, enable, MEM2_ReadAddr2
    );

    MEM2_WB_FF_ImmediateVal : D_FF GENERIC MAP(
        16
        ) PORT MAP (ImmediateVal, clk, rst, enable, MEM2_ImmediateVal
    );

    MEM2_WB_ALU_RESULT : D_FF GENERIC MAP(
        16
        ) PORT MAP (ALU_Result, clk, rst, enable, MEM2_ALU_Result
    );

    MEM2_WB_FF_PC : D_FF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, MEM2_PC
    );

    -- MEM2_WB_FF_SP : D_FF GENERIC MAP(
    --     16
    --     ) PORT MAP (SP, clk, rst, enable, MEM2_SP
    -- );

END ARCHITECTURE rtl;