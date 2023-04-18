LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Memory IS
    PORT (
        clk, we : IN STD_LOGIC;
        WriteData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ReadData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteEnable : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        ReadAddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Memory;

ARCHITECTURE rtl OF Memory IS

    TYPE ram_type IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL ram : ram_type;

BEGIN
    PROCESS (clk) IS
    BEGIN
        IF rising_edge(clk) THEN
            IF we = '1' THEN
                ram(to_integer(unsigned(WriteData))) <= WriteData;
            END IF;
        END IF;
    END PROCESS;
    ReadData <= ram(to_integer(unsigned(ReadAddr)));
END ARCHITECTURE rtl;