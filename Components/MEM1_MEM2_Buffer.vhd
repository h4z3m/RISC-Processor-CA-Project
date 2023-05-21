LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY MEM1_MEM2_Buffer IS
    PORT (
        -- Inputs
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        interrupt : IN STD_LOGIC;
        ControlUnitOutput : IN STD_LOGIC_VECTOR(12 DOWNTO 0);
        FlagRegister : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Writeback_RegAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ImmediateVal : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PORTOUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataMemory_ReadAddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataMemory_WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        DataMemory_Mode : IN STD_LOGIC;
        -- SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        -- Outputs
        MEM1_ControlUnitOutput : OUT STD_LOGIC_VECTOR(12 DOWNTO 0);
        MEM1_FlagRegister : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_Writeback_RegAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM1_ImmediateVal : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_ALU_Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_PC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_PORTOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_DataMemory_ReadAddr : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM1_DataMemory_WriteData : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        MEM1_DataMemory_Mode : OUT STD_LOGIC;
        MEM1_Interrupt : OUT STD_LOGIC
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

    MEM1_MEM2_FF_Writeback_RegAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (Writeback_RegAddr, clk, rst, enable, MEM1_Writeback_RegAddr
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

    MEM1_MEM2_FF_DataMemory_ReadAddr : D_FF GENERIC MAP(
        16
        ) PORT MAP (DataMemory_ReadAddr, clk, rst, enable, MEM1_DataMemory_ReadAddr
    );

    MEM1_MEM2_FF_DataMemory_WriteData : D_FF GENERIC MAP(
        32
        ) PORT MAP (DataMemory_WriteData, clk, rst, enable, MEM1_DataMemory_WriteData
    );

    MEM1_MEM2_FF_DataMemory_Mode : ENTITY work.D_FF_1
        PORT MAP(
            D => DataMemory_Mode,
            CLK => CLK,
            RST => RST,
            EN => enable,
            Q => MEM1_DataMemory_Mode
        );
    MEM1_MEM2_FF_Interrupt : ENTITY work.D_FF_1
        PORT MAP(
            D => interrupt,
            CLK => CLK,
            RST => RST,
            EN => enable,
            Q => MEM1_Interrupt
        );
END ARCHITECTURE rtl;