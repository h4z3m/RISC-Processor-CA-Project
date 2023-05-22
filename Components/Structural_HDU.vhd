LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY Structural_HDU IS
    GENERIC (
        stall_cycles : INTEGER := 1
    );
    PORT (
        clk : IN STD_LOGIC;
        memRead_ID_EX : IN STD_LOGIC;
        memWrite_ID_EX : IN STD_LOGIC;
        memRead_EX_M1 : IN STD_LOGIC;
        memWrite_EX_M1 : IN STD_LOGIC;
        stall_condition : OUT STD_LOGIC
    );

END ENTITY Structural_HDU;

ARCHITECTURE Structural_HDU_Implementation OF Structural_HDU IS
    SIGNAL counter : STD_LOGIC := '1';
    SIGNAL is_stalling : STD_LOGIC := '0';
BEGIN
    -- Condition   
    PROCESS (clk, counter, is_stalling)
    BEGIN
        IF rising_edge(clk) THEN
            IF (memRead_ID_EX = '1' OR memWrite_ID_EX = '1') AND (memRead_EX_M1 = '1' OR memWrite_EX_M1 = '1') AND is_stalling = '0' THEN
                is_stalling <= '1';
                stall_condition <= '0';
                counter <= '1';
            ELSIF counter = '0' THEN
                counter <= '1';
                stall_condition <= '1';
                is_stalling <= '0';
            ELSIF is_stalling = '1' THEN
                counter <= '0';
            ELSE
                stall_condition <= '1';
                is_stalling <= '0';
                counter <= '1';
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE Structural_HDU_Implementation;