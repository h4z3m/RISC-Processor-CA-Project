LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;

ENTITY UpdateFlagRegister IS
    PORT (
        current_flags : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Control Signals --
        flagEN : IN STD_LOGIC;
        aluSrc : IN STD_LOGIC;
        decode_branch : IN STD_LOGIC;
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
        carry_flag_enable : OUT STD_LOGIC;
        update_pc_carry : OUT STD_LOGIC;
        update_pc_zero : OUT STD_LOGIC

    );
END UpdateFlagRegister;
ARCHITECTURE Behavioral OF UpdateFlagRegister IS
    SIGNAL temp_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL correct_flags : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN

    PROCESS (ALL)
    BEGIN
        IF (memRead_mem2_stage AND jump_mem2_stage) THEN
            temp_flags(2) <= dataMem_return(2);
            temp_flags(1) <= dataMem_return(1);
            temp_flags(0) <= dataMem_return(0);
            ELSE
            temp_flags(1) <= aluNeg;
            temp_flags(0) <= aluZero;
            IF (NOT aluOp(2) AND (aluOp(1) OR aluOp(0))) THEN
                temp_flags(2) <= carryOld;
                ELSE
                -- IF (jump AND memread) THEN
                IF flagEN AND portEn THEN
                    temp_flags(2) <= aluSrc;
                    ELSE
                    temp_flags(2) <= aluCarry;
                END IF;
            END IF;
        END IF;

        carry_flag_enable <= (flagen OR (jump_mem2_stage AND memread_mem2_stage) OR decode_branch) AND stall_signal;

        IF carry_flag_enable = '1' THEN
            correct_flags <= temp_flags;
            ELSE
            correct_flags <= current_flags;
        END IF;

        IF decode_branch = '1' THEN
            IF correct_flags(2) = '1' THEN
                -- carry
                outFlags <= '0' & correct_flags(1 DOWNTO 0);
                update_pc_zero <= '0';
                update_pc_carry <= '1';

                ELSIF correct_flags(0) = '1' THEN
                -- zero
                outFlags <= correct_flags(2 DOWNTO 1) & '0';
                update_pc_zero <= '1';
                update_pc_carry <= '0';

                ELSE
                outFlags <= correct_flags;
                update_pc_carry <= '0';
                update_pc_zero <= '0';

            END IF;
            ELSE
            outFlags <= correct_flags;
            update_pc_carry <= '0';
            update_pc_zero <= '0';
        END IF;
    END PROCESS;

END ARCHITECTURE;