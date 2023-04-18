LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY MEM1_MEM2_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        ControlUnitOutput : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
        FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        SignExtOut : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        MEM1_ControlUnitOutput : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
        MEM1_FlagRegister : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_WriteAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_ReadAddr2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_SignExtOut : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM1_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_SP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY MEM1_MEM2_Buffer;

ARCHITECTURE rtl OF MEM1_MEM2_Buffer IS

    COMPONENT DFF IS
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
    MEM1_MEM2_FF_ControlUnitOutput : DFF GENERIC MAP(
        10
        ) PORT MAP (ControlUnitOutput, clk, rst, enable, MEM1_ControlUnitOutput
    );

    MEM1_MEM2_FF_FlagRegister : DFF GENERIC MAP(
        3
        ) PORT MAP (FlagRegister, clk, rst, enable, MEM1_FlagRegister
    );

    MEM1_MEM2_FF_WriteAddr : DFF GENERIC MAP(
        3
        ) PORT MAP (WriteAddr, clk, rst, enable, MEM1_WriteAddr
    );

    MEM1_MEM2_FF_ReadAddr2 : DFF GENERIC MAP(
        3
        ) PORT MAP (ReadAddr2, clk, rst, enable, MEM1_ReadAddr2
    );

    MEM1_MEM2_FF_SignExtOut : DFF GENERIC MAP(
        32
        ) PORT MAP (SignExtOut, clk, rst, enable, MEM1_SignExtOut
    );

    MEM1_MEM2_ALU_RESULT : DFF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, MEM1_ALU_Result
    );

    MEM1_MEM2_FF_PC : DFF GENERIC MAP(
        16
        ) PORT MAP (PC, clk, rst, enable, MEM1_PC
    );

    MEM1_MEM2_FF_SP : DFF GENERIC MAP(
        16
        ) PORT MAP (SP, clk, rst, enable, MEM1_SP
    );

END ARCHITECTURE rtl;