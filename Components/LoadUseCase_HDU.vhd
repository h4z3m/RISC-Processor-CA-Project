LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY LoadUseCase_HDU IS
    GENERIC (
        stall_cycles : INTEGER := 3
    );
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        Jump : IN STD_LOGIC;

        IF_ID_Rs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        IF_ID_Rt : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_Rs : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_Rt : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ID_EX_MemRead : IN STD_LOGIC;
        ID_EX_RegWrite : IN STD_LOGIC;
        ID_EX_PortEn : IN STD_LOGIC;
        ID_EX_ALUsrc : IN STD_LOGIC;
        STALL_SIGNAL : OUT STD_LOGIC
    );
END ENTITY LoadUseCase_HDU;

ARCHITECTURE rtl OF LoadUseCase_HDU IS
    SIGNAL counter : STD_LOGIC_VECTOR(2 DOWNTO 0) := STD_LOGIC_VECTOR(
    to_unsigned(stall_cycles - 1, 3)
    );
    SIGNAL is_stalling : STD_LOGIC := '0';
BEGIN

    PROCESS (clk, is_stalling, counter)
    BEGIN
        IF rising_edge(clk) THEN

            -- Check load use condition
            IF
                (
                (ID_EX_Rs = IF_ID_Rt) OR (ID_EX_Rt = IF_ID_Rs)
                OR
                (ID_EX_Rt = IF_ID_Rt AND ID_EX_ALUsrc = '0')
                )

                AND

                (
                (ID_EX_MemRead = '1' AND ID_EX_RegWrite = '1')
                OR
                (ID_EX_PortEn = '1' AND ID_EX_RegWrite = '1')
                OR
                (ID_EX_RegWrite = '1' AND Jump = '1')
                )

                AND

                (is_stalling = '0')

                THEN
                is_stalling <= '1';
                STALL_SIGNAL <= '0';
                IF jump = '1' THEN
                    counter <= STD_LOGIC_VECTOR(to_unsigned(stall_cycles, counter'length));
                    ELSE
                    counter <= STD_LOGIC_VECTOR(to_unsigned(stall_cycles - 1, counter'length));
                END IF;
                ELSIF counter = "000" THEN
                is_stalling <= '0';
                counter <= STD_LOGIC_VECTOR(to_unsigned(stall_cycles - 1, counter'length));
                STALL_SIGNAL <= '1';
                ELSIF is_stalling = '1' THEN
                counter <= STD_LOGIC_VECTOR(to_unsigned(to_integer(unsigned(counter)) - 1, 3));
                ELSE
                is_stalling <= '0';
                counter <= STD_LOGIC_VECTOR(to_unsigned(stall_cycles - 1, counter'length));
                STALL_SIGNAL <= '1';
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;