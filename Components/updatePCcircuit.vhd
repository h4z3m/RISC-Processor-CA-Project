LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY updatePCcircuit IS
    PORT (
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        Interrupt_buffered : IN STD_LOGIC;
        Reset : IN STD_LOGIC;
        Reset_buffered : IN STD_LOGIC;
        Interrupt : IN STD_LOGIC;
        Zero_flag : IN STD_LOGIC;
        Carry_flag : IN STD_LOGIC;
        type_sig : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        external_type_sig : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        SIG_AluOP0 : IN STD_LOGIC;
        rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        LoadUseCase_Stall : IN STD_LOGIC;
        Structural_Stall : IN STD_LOGIC;

        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;
ARCHITECTURE Behavioral OF updatePCcircuit IS
    SIGNAL Updated_PC : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL mux_out_type_signal : STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN
    mux_inst : ENTITY work.MUX
        GENERIC MAP(
            n => 2
        )
        PORT MAP(
            in0 => type_sig,
            in1 => external_type_sig,
            sel => Reset_buffered,
            out1 => mux_out_type_signal
        );

    PROCESS (ALL)
    BEGIN
        IF (external_type_sig = "00") THEN
            Updated_PC <= STD_LOGIC_VECTOR(unsigned(PC) + 2);
        ELSE
            Updated_PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
        END IF;

        IF (
            (NOT Reset_buffered AND reset)
            OR
            (NOT Interrupt_buffered AND Interrupt)
            OR (SIG_Branch AND SIG_Jump)
            OR (NOT LoadUseCase_Stall) OR (NOT Structural_Stall)
            ) THEN
            PC_out <= PC;
        ELSIF (SIG_Jump) THEN
            pc_out <= rdst;
        ELSIF (SIG_Branch) THEN
            IF ((SIG_AluOP0 AND Carry_flag) OR (NOT SIG_AluOP0 AND Zero_flag)) THEN
                pc_out <= rdst;
            ELSE
                pc_out <= Updated_PC;
            END IF;
        ELSE
            pc_out <= Updated_PC;
        END IF;

    END PROCESS;
END ARCHITECTURE;