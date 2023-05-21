LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
LIBRARY work;

ENTITY D_FF_1 IS

    PORT (
        D : IN STD_LOGIC;
        CLK, RST, EN : IN STD_LOGIC;
        Q : OUT STD_LOGIC
    );
END D_FF_1;

ARCHITECTURE A_MY_D_FF OF D_FF_1 IS
BEGIN
    PROCESS (CLK, RST)
    BEGIN
        IF (RST = '1') THEN
            Q <= '0';
        ELSIF falling_edge(CLK) THEN
            IF EN = '1' THEN
                Q <= D;
            END IF;
        END IF;
    END PROCESS;
END A_MY_D_FF;