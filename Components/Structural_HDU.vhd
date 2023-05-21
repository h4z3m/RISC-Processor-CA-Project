LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY Structural_HDU IS
    PORT (
        memRead_ID_EX : IN STD_LOGIC;
        memWrite_ID_EX : IN STD_LOGIC;
        memRead_EX_M1 : IN STD_LOGIC;
        memWrite_EX_M1 : IN STD_LOGIC;
        stall_condition : OUT STD_LOGIC
    );

END ENTITY Structural_HDU;

ARCHITECTURE Structural_HDU_Implementation OF Structural_HDU IS
BEGIN
    -- Condition   
    PROCESS (memRead_ID_EX, memWrite_ID_EX, memRead_EX_M1, memWrite_EX_M1)
    BEGIN
        IF (memRead_ID_EX = '1' OR memWrite_ID_EX = '1') AND (memRead_EX_M1 = '1' OR memWrite_EX_M1 = '1') THEN
            stall_condition <= '0';
        ELSE
            stall_condition <= '1';
        END IF;
    END PROCESS;
END ARCHITECTURE Structural_HDU_Implementation;