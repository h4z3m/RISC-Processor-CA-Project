LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY MEM2_WB_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        enable : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        WriteBackAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        WriteBackData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PORTOUT : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        MEM2_WriteBackAddr : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        MEM2_WriteBackData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        MEM2_PORTOUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        -- MEM2_SP : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY MEM2_WB_Buffer;

ARCHITECTURE rtl OF MEM2_WB_Buffer IS

    COMPONENT D_FF IS
        GENERIC (
            N : INTEGER := 16
        );
        PORT (
            D : IN STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
            CLK, RST, EN : IN STD_LOGIC;
            Q : OUT STD_LOGIC_VECTOR(N - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    MEM2_WB_FF_WriteBackAddr : D_FF GENERIC MAP(
        3
        ) PORT MAP (WriteBackAddr, clk, rst, enable, MEM2_WriteBackAddr
    );

    MEM2_WB_FF_WriteBackData : D_FF GENERIC MAP(
        16
        ) PORT MAP (WriteBackData, clk, rst, enable, MEM2_WriteBackData
    );
    MEM2_WB_FF_PORTOUT : D_FF GENERIC MAP(
        16
        ) PORT MAP (PORTOUT, clk, rst, enable, MEM2_PORTOUT
    );

END ARCHITECTURE rtl;