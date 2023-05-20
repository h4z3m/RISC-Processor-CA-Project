LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY updatePCcircuit IS
    PORT (
        M2_WB_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_RS : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        M2_WB_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RD : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_RT : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        RegDst : IN STD_LOGIC;
        ID_EX_RegWrite : IN STD_LOGIC;
        M1_M2_RegWrite : IN STD_LOGIC;
        wb_data : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        alu_result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        read_data1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        rdst_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;
ARCHITECTURE Behavioral OF updatePCcircuit IS
    SIGNAL Forward_from_mem2 : STD_LOGIC;
    SIGNAL Forward_from_ex : STD_LOGIC;
BEGIN
    PROCESS (ALL)
    BEGIN
        if (id_ex_regwrite = '1' and ((id_ex_rt = IF_ID_RS and regdst = '0') or (IF_ID_RS = id_ex_rd and )))
    END PROCESS;
END ARCHITECTURE;