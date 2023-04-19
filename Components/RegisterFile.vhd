LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
library work;
USE ieee.math_real.ALL;

ENTITY RegisterFile IS
    GENERIC (
        DATA_WIDTH : INTEGER := 16;
        REG_COUNT : INTEGER := 4
    );
    PORT (
        CLK, WR_ENABLE, RST : IN STD_LOGIC;
        WRITE_PORT : IN STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
        WRITE_ADDR : IN STD_LOGIC_VECTOR(INTEGER(CEIL(LOG(REAL(REG_COUNT)))) - 1 DOWNTO 0);

        READ_ADDR_1 : IN STD_LOGIC_VECTOR(INTEGER(CEIL(LOG(REAL(REG_COUNT)))) - 1 DOWNTO 0);
        READ_PORT_1 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);

        READ_ADDR_2 : IN STD_LOGIC_VECTOR(INTEGER(CEIL(LOG(REAL(REG_COUNT)))) - 1 DOWNTO 0);
        READ_PORT_2 : OUT STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF RegisterFile IS
    TYPE REG_MEM IS ARRAY(0 TO REG_COUNT - 1) OF STD_LOGIC_VECTOR(DATA_WIDTH - 1 DOWNTO 0);
    SIGNAL Regs : REG_MEM;
BEGIN

    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            -- Write to registers
            IF RST = '1' THEN
                Regs(0 TO REG_COUNT - 1) <= (OTHERS => (OTHERS => '0'));
            ELSIF WR_ENABLE = '1' THEN
                Regs(to_integer(unsigned(WRITE_ADDR))) <= WRITE_PORT;
            ELSE
                Regs <= Regs;
            END IF;
        END IF;
    END PROCESS;
    -- Read from registers
    READ_PORT_1 <= Regs(to_integer(unsigned(READ_ADDR_1)));
    READ_PORT_2 <= Regs(to_integer(unsigned(READ_ADDR_2)));
END ARCHITECTURE rtl;