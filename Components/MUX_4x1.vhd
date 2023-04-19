LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY MUX_4x1 IS
    GENERIC (n : INTEGER := 16);
    PORT (
        in0, in1, in2, in3 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        sel : IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        out1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
END MUX_4x1;
ARCHITECTURE when_else_mux OF MUX_4x1 IS
BEGIN

    out1 <= in0 WHEN sel = "00"
        ELSE
        in1 WHEN sel = "01"
        ELSE
        in2 WHEN sel = "10"
        ELSE
        in3;
END when_else_mux;