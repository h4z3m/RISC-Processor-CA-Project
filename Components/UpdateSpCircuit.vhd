LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY UpdateSpCircuit IS
    PORT (
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIG_MemRead : IN STD_LOGIC;
        SIG_MemWrite : IN STD_LOGIC;
        SIG_ALUsrc : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SP_Modified : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY UpdateSpCircuit;
ARCHITECTURE Behavioral OF UpdateSpCircuit IS
BEGIN
    PROCESS (ALL)
    BEGIN
        IF (SIG_jump AND SIG_branch) THEN
            SP_Modified <= "0000001111111110";---------- For call/int which push 32bits to the stack
        ELSE
            IF (NOT SIG_MemRead AND SIG_MemWrite AND NOT SIG_ALUsrc) THEN
                SP_Modified <= STD_LOGIC_VECTOR(to_unsigned(to_integer((signed(SP)) - 2), 16));
            ELSIF (SIG_MemRead AND NOT SIG_MemWrite AND NOT SIG_ALUsrc) THEN
                --add 2 to SP
                SP_Modified <= STD_LOGIC_VECTOR(to_unsigned(to_integer((signed(SP)) + 2), 16));
            ELSE
                SP_Modified <= SP;

            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE;