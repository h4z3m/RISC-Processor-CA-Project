LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
library work;

ENTITY OUTPUT_PORT IS
    GENERIC (n : INTEGER := 16);
    PORT (
        port_value : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        enable : IN STD_LOGIC;
        out_value : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF OUTPUT_PORT IS
BEGIN
    out_value <= port_value WHEN enable = '1';
END ARCHITECTURE rtl;