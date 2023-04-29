LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY work;
ENTITY D_FF IS
    GENERIC (
        N : INTEGER := 16
    );
    PORT (
        D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        CLK, RST, EN : IN STD_LOGIC;
        Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END D_FF;

ARCHITECTURE A_MY_D_FF OF D_FF IS
BEGIN
    PROCESS (CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            Q <= (OTHERS => '0');
        ELSIF falling_edge(CLK) THEN
            IF EN = '1' THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END A_MY_D_FF;