LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY OPForwardingUnit IS
    PORT (
        -- Inputs
        RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Ex_M1_Regw : IN STD_LOGIC;
        M1_M2_Regw : IN STD_LOGIC;
        M2_WB_Regw : IN STD_LOGIC;
        WB_DATA_M2_WB : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_DATA : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_RESULT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OP2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WB_ADDRESS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        OUT_OF_MUX_MEM1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WB_ADDRESS_M2_WB : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- Outputs
        OUT_OF_MUX_OP1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        OUT_OF_MUX_OP2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY OPForwardingUnit;
ARCHITECTURE Behavioral OF OPForwardingUnit IS
BEGIN
    PROCESS (ALL)
    BEGIN

        IF (((RS = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) OR ((RS = WB_ADDRESS) AND (M1_M2_Regw = '1')) OR ((RS = WB_ADDRESS_M2_WB) AND (M2_WB_Regw = '1'))) THEN
            IF ((RS = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) THEN
                OUT_OF_MUX_OP1 <= ALU_RESULT;
            ELSIF ((RS = WB_ADDRESS) AND (M1_M2_Regw = '1')) THEN
                OUT_OF_MUX_OP1 <= WB_DATA;
            ELSE
                OUT_OF_MUX_OP1 <= WB_DATA_M2_WB;
            END IF;
        ELSE
            OUT_OF_MUX_OP1 <= OP1;
        END IF;

        IF (((RT = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) OR ((RT = WB_ADDRESS) AND (M1_M2_Regw = '1')) OR ((RT = WB_ADDRESS_M2_WB) AND (M2_WB_Regw = '1'))) THEN
            IF ((RT = OUT_OF_MUX_MEM1) AND (EX_M1_REGW = '1')) THEN
                OUT_OF_MUX_OP2 <= ALU_RESULT;
            ELSIF ((RT = WB_ADDRESS) AND (M1_M2_Regw = '1')) THEN
                OUT_OF_MUX_OP2 <= WB_DATA;
            ELSE
                OUT_OF_MUX_OP2 <= WB_DATA_M2_WB;
            END IF;
        ELSE
            OUT_OF_MUX_OP2 <= OP2;
        END IF;

    END PROCESS;
END ARCHITECTURE;