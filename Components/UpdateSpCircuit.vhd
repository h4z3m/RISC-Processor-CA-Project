LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY UpdateSpCircuit IS
    PORT (
        -- Inputs
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIG_MemRead : IN STD_LOGIC;
        SIG_MemWrite : IN STD_LOGIC;
        SIG_FlagEn : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        SIG_ALUsrc : IN STD_LOGIC;
        reset : IN STD_LOGIC;

        -- Outputs
        SP_Modified : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        SP_Enable : OUT STD_LOGIC;
        SP_MODE : OUT STD_LOGIC
    );

END ENTITY UpdateSpCircuit;
ARCHITECTURE Behavioral OF UpdateSpCircuit IS
    SIGNAL SP_TEMP : STD_LOGIC_VECTOR(9 DOWNTO 0);
BEGIN
    PROCESS (SIG_MemRead, SIG_MemWrite, SIG_FlagEn, Interrupt, SIG_ALUsrc, reset)
    BEGIN
        SP_TEMP <= SP(9 DOWNTO 0);
        IF (sig_flagen OR Interrupt) THEN
            sp_mode <= '1';
        ELSE
            sp_mode <= '0';
        END IF;

        IF (reset) THEN
            SP_TEMP <= "1111111110";---------- For call/int which push 32bits to the stack
        ELSE
            IF (SIG_MemRead = '0' AND (SIG_FlagEn OR Interrupt) = '0') THEN
                SP_TEMP <= STD_LOGIC_VECTOR(to_unsigned(to_integer((unsigned(SP(9 DOWNTO 0))) - 1), 10));
            ELSIF (SIG_MemRead = '0' AND (SIG_FlagEn OR Interrupt) = '1') THEN
                SP_TEMP <= STD_LOGIC_VECTOR(to_unsigned(to_integer((unsigned(SP(9 DOWNTO 0))) - 2), 10));
            ELSIF (SIG_MemRead = '1' AND (SIG_FlagEn OR Interrupt) = '0') THEN
                SP_TEMP <= STD_LOGIC_VECTOR(to_unsigned(to_integer((unsigned(SP(9 DOWNTO 0))) + 1), 10));
            ELSIF (SIG_MemRead = '1' AND (SIG_FlagEn OR Interrupt) = '1') THEN
                SP_TEMP <= STD_LOGIC_VECTOR(to_unsigned(to_integer((unsigned(SP(9 DOWNTO 0))) + 2), 10));
            ELSE
                SP_TEMP <= SP(9 DOWNTO 0);
            END IF;
            REPORT "SP_Modified = " & to_string(SP_Modified);
        END IF;
        IF ((NOT sig_alusrc AND sig_memwrite) OR (NOT sig_alusrc AND sig_memread) OR Interrupt OR reset) THEN
            SP_Enable <= '1';
        ELSE
            SP_Enable <= '0';
        END IF;
    END PROCESS;
    SP_Modified <= "000000" & SP_TEMP;

END ARCHITECTURE;