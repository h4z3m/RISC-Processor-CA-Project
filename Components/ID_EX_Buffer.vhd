LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY ID_EX_Buffer IS
    PORT (
        -- Inputs
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        ControlUnitOutput : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        RegisterFile_ReadData1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        RegisterFile_ReadData2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ImmediateVal : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- Outputs
        ID_Interrupt : OUT STD_LOGIC;
        ID_ControlUnitOutput : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        ID_RegisterFile_ReadData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_RegisterFile_ReadData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_ReadAddr1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ID_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY ID_EX_Buffer;

ARCHITECTURE rtl OF ID_EX_Buffer IS

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
    ID_EX_FF_ControlUnitOutput : D_FF GENERIC MAP(
        13
        ) PORT MAP (ControlUnitOutput, clk, rst, enable, ID_ControlUnitOutput
    );

    ID_EX_FF_RegisterFile_ReadData1 : D_FF GENERIC MAP(
        16
        ) PORT MAP (RegisterFile_ReadData1, clk, rst, enable, ID_RegisterFile_ReadData1
    );

    ID_EX_FF_RegisterFile_ReadData2 : D_FF GENERIC MAP(
        16
        ) PORT MAP (RegisterFile_ReadData2, clk, rst, enable, ID_RegisterFile_ReadData2
    );

    ID_EX_FF_RS : D_FF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr1, clk, rst, enable, ID_ReadAddr1
    );

    ID_EX_FF_WriteAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (WriteAddr, clk, rst, enable, ID_WriteAddr
    );

    ID_EX_FF_ReadAddr2 : D_FF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr2, clk, rst, enable, ID_ReadAddr2
    );

    ID_EX_FF_ImmediateVal : D_FF GENERIC MAP(
        16
        ) PORT MAP (ImmediateVal, clk, rst, enable, ID_ImmediateVal
    );

    ID_EX_FF_PC : D_FF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, ID_PC
    );
    ID_EX_FF_INTERRUPT : ENTITY work.D_FF_1
        PORT MAP(
            interrupt, clk, rst, enable, ID_Interrupt
        );

    -- ID_EX_FF_SP : D_FF GENERIC MAP(
    --     16
    --     ) PORT MAP (SP, clk, rst, enable, ID_SP
    -- );

END ARCHITECTURE rtl;