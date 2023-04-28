LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY MUX IS

    GENERIC (n : INTEGER := 16);
    PORT (
        in0, in1 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        sel : IN STD_LOGIC;
        out1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0));
END MUX;

ARCHITECTURE when_else_mux OF MUX IS

BEGIN
    out1 <= in0 WHEN sel = '0'
        ELSE
        in1;
END when_else_mux;