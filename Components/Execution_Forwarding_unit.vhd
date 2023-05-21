LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY Execution_Forwarding_unit IS
    PORT (
        M1_M2_WB_Addr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RegDst : IN STD_LOGIC;
        ID_EX_RegWrite : IN STD_LOGIC;
        M1_M2_RegWrite : IN STD_LOGIC;
        wb_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        rdst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY Execution_Forwarding_unit;

ARCHITECTURE Behavioral OF Execution_Forwarding_unit IS
    SIGNAL Forward_from_mem2 : STD_LOGIC;
    SIGNAL Forward_from_ex : STD_LOGIC;
BEGIN
    PROCESS (ALL)
    BEGIN
        IF (id_ex_regwrite = '1' AND ((id_ex_rt = IF_ID_RS AND ID_EX_RegDst = '0') OR (IF_ID_RS = id_ex_rd AND ID_EX_RegDst = '1'))) THEN
            Forward_from_ex <= '1';
        ELSE
            Forward_from_ex <= '0';
        END IF;
        IF (m1_m2_regwrite = '1' AND (M1_M2_WB_Addr = IF_ID_RS)) THEN
            Forward_from_mem2 <= '1';
        ELSE
            Forward_from_mem2 <= '0';
        END IF;

        IF (Forward_from_ex = '0' AND Forward_from_mem2 = '0') THEN
            rdst_out <= read_data1;
        ELSE
            IF (Forward_from_ex = '1') THEN
                rdst_out <= alu_result;
            ELSE
                rdst_out <= wb_data;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;