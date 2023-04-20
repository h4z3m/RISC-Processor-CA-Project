LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.math_real.ALL;
LIBRARY work;
ENTITY Memory IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        CELL_COUNT : INTEGER := 4
    );
    PORT (
        clk, write_enable : IN STD_LOGIC;
        WriteData : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        ReadData : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        ReadAddr : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(CELL_COUNT)))) - 1 DOWNTO 0)
    );
END ENTITY Memory;

ARCHITECTURE rtl OF Memory IS

    TYPE ram_type IS ARRAY(0 TO CELL_COUNT - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF write_enable = '1' THEN
                ram(to_integer(unsigned(ReadAddr))) <= WriteData;
            END IF;
        END IF;
    END PROCESS;
    ReadData <= ram(to_integer(unsigned(ReadAddr)));
END ARCHITECTURE rtl;