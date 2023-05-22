LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY OUTPUT_PORT IS
    GENERIC (n : INTEGER := 16);
    PORT (
        port_value : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
        enable : IN STD_LOGIC;
        out_value : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
    );
END ENTITY;

-- ARCHITECTURE rtl OF OUTPUT_PORT IS
-- BEGIN
--     PROCESS (enable, port_value)
--     BEGIN
--         IF enable = '1' THEN
--             out_value <= port_value;
--         END IF;
--     END PROCESS;
-- END ARCHITECTURE rtl;
ARCHITECTURE rtl OF OUTPUT_PORT IS
    SIGNAL latched_value : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
BEGIN
    PROCESS (enable, port_value)
    BEGIN
        IF enable = '1' THEN
            latched_value <= port_value; -- Latch the input value
        END IF;
        out_value <= latched_value; -- Assign the latched value to the output
    END PROCESS;
END ARCHITECTURE rtl;