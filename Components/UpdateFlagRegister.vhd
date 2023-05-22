LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY UpdateFlagRegister IS
    PORT (
        -- Control Signals --
        flagEN : IN STD_LOGIC;
        aluSrc : IN STD_LOGIC;
        jump : IN STD_LOGIC;
        memRead : IN STD_LOGIC;
        porten : IN STD_LOGIC;
        jump_mem2_stage : IN STD_LOGIC;
        memread_mem2_stage : IN STD_LOGIC;
        aluOp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Alu Data --
        aluCarry : IN STD_LOGIC;
        aluNeg : IN STD_LOGIC;
        aluZero : IN STD_LOGIC;

        stall_signal : IN STD_LOGIC;

        -- Data mem --
        dataMem_return : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- carry old value --
        carryOld : IN STD_LOGIC;

        -- Output --
        -- outFlags(2): Carry
        -- outFlags(1): Negative
        -- outFlags(0): Zero
        outFlags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        carry_flag_enable : OUT STD_LOGIC
    );
END UpdateFlagRegister;
ARCHITECTURE Behavioral OF UpdateFlagRegister IS
BEGIN

    PROCESS (ALL)
    BEGIN
        IF (memRead_mem2_stage AND jump_mem2_stage) THEN
            outFlags(2) <= dataMem_return(2);
            outFlags(1) <= dataMem_return(1);
            outFlags(0) <= dataMem_return(0);
        ELSE
            outFlags(1) <= aluNeg;
            outFlags(0) <= aluZero;
            IF (NOT aluOp(2) AND (aluOp(1) OR aluOp(0))) THEN
                outFlags(2) <= carryOld;
            ELSE
                -- IF (jump AND memread) THEN
                IF flagEN AND portEn THEN
                    outFlags(2) <= aluSrc;
                ELSE
                    outFlags(2) <= aluCarry;
                END IF;
            END IF;
        END IF;
        carry_flag_enable <= (flagen OR (jump_mem2_stage AND memread_mem2_stage)) AND stall_signal;
    END PROCESS;

END ARCHITECTURE;