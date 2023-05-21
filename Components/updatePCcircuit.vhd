LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY updatePCcircuit IS
    PORT (
        rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Ret_Reti : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIG_MemRead : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SIG_AluOP0 : IN STD_LOGIC;
        Zero_flag : IN STD_LOGIC;
        Carry_flag : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        type_sig : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;
ARCHITECTURE Behavioral OF updatePCcircuit IS
    SIGNAL Updated_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    PROCESS (ALL)
    BEGIN
        IF (type_sig = "00") THEN
            Updated_PC <= STD_LOGIC_VECTOR(unsigned(PC) + 2);
        ELSE
            Updated_PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
        END IF;

        IF (Interrupt OR Reset OR (SIG_Branch AND SIG_Jump)) THEN
            PC_out <= PC;
        ELSIF (SIG_Jump) THEN
            IF (SIG_MemRead) THEN
                pc_out <= Ret_Reti;
            ELSE
                pc_out <= rdst;
            END IF;
        ELSIF (SIG_Branch) THEN
            IF ((Sig_aluop0 AND carry_flag) OR (NOT Sig_aluop0 AND Zero_flag)) THEN
                PC_out <= rdst;
            ELSE
                pc_out <= Updated_PC;
            END IF;
        ELSE
            pc_out <= Updated_PC;
        END IF;

    END PROCESS;
END ARCHITECTURE;