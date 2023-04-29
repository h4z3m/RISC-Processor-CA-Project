LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY updatePCcircuit IS
    PORT (
        rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Return_Stack : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Flag_en : IN STD_LOGIC;
        SIG_MemRead : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SIG_AluOP0 : IN STD_LOGIC;
        Zero_flag : IN STD_LOGIC;
        Carry_flag : IN STD_LOGIC;
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;
ARCHITECTURE Behavioral OF updatePCcircuit IS
BEGIN
    PROCESS (ALL)
    BEGIN
        IF (SIG_Branch AND SIG_Jump) THEN
            PC_out <= (OTHERS => '0');
        ELSIF (SIG_Branch AND NOT SIG_Jump) THEN
            IF ((Sig_aluop0 AND carry_flag) OR (NOT Sig_aluop0 AND Zero_flag)) THEN
                PC_out <= rdst;
            ELSE
                pc_out <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
            END IF;
        ELSIF (SIG_Jump AND NOT SIG_Branch) THEN
            IF (SIG_MemRead) THEN
                pc_out <= PC_Return_Stack;
            ELSIF (flag_en) THEN
                pc_out <= "0000000000000001";
            ELSE
                pc_out <= rdst;
            END IF;
        ELSE
            pc_out <= STD_LOGIC_VECTOR(unsigned(pc) + 1);

        END IF;
    END PROCESS;
END ARCHITECTURE;