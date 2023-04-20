LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY INPUT_PORT IS
    GENERIC (n : INTEGER := 16);
    PORT (
        in_value : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        enable : IN STD_LOGIC;
        port_value : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF INPUT_PORT IS
BEGIN
    port_value <= in_value WHEN enable = '1' else port_value;

END ARCHITECTURE rtl;