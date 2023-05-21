LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY updatePCcircuit IS
    PORT (
        RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Ex_M1_Regw : IN STD_LOGIC;
        M1_M2_Regw : IN STD_LOGIC;
        WB_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_RESULT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_ADDRESS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_OF_MUX_MEM1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_OF_MUX_OP1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_OF_MUX_OP2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;
ARCHITECTURE Behavioral OF updatePCcircuit IS
    SIGNAL MUX_OP2_SEL : STD_LOGIC;
    SIGNAL MUX_OP1_SEL : STD_LOGIC;
    SIGNAL MUX_OP2_INPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL MUX_OP1_INPUT : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    PROCESS (ALL)
    BEGIN
        IF ((RS = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) THEN
            MUX_OP1_INPUT <= ALU_RESULT;
        ELSE
            MUX_OP1_INPUT <= WB_DATA;
        END IF;

        IF ((RT = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) THEN
            MUX_OP2_INPUT <= ALU_RESULT;
        ELSE
            MUX_OP2_INPUT <= WB_DATA;
        END IF;

        IF (((RS = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) OR ((RS = WB_ADDRESS) AND (M1_M2_REGW = '1'))) THEN
            MUX_OP1_SEL <= '1';
        ELSE
            MUX_OP1_SEL <= '0';
        END IF;

        IF (((RT = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) OR ((RT = WB_ADDRESS) AND (M1_M2_REGW = '1'))) THEN
            MUX_OP2_SEL <= '1';
        ELSE
            MUX_OP2_SEL <= '0';
        END IF;

        IF (MUX_OP1_SEL = '1') THEN
            OUT_OF_MUX_OP1 <= MUX_OP1_INPUT;
        ELSE
            OUT_OF_MUX_OP1 <= OP1;
        END IF;

        IF (MUX_OP2_SEL = '1') THEN
            OUT_OF_MUX_OP2 <= MUX_OP2_INPUT;
        ELSE
            OUT_OF_MUX_OP2 <= OP2;
        END IF;

    END PROCESS;
END ARCHITECTURE;