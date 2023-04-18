LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY UpdateFlagRegister IS
    PORT (
        -- Control Signals --
        flagEN : IN STD_LOGIC;
        aluSrc : IN STD_LOGIC;
        portEN : IN STD_LOGIC;
        jump : IN STD_LOGIC;
        memRead : IN STD_LOGIC;
        aluOp : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        -- Alu Data --
        aluCarry : IN STD_LOGIC;
        aluNeg : IN STD_LOGIC;
        aluZero : IN STD_LOGIC;

        -- Data mem --
        dataMem : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        -- carry old value --
        carryOld : IN STD_LOGIC;

        -- Output --
        -- outFlags(2): Carry
        -- outFlags(1): Negative
        -- outFlags(0): Zero
        outFlags : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
END UpdateFlagRegister;
ARCHITECTURE Behavioral OF UpdateFlagRegister IS
BEGIN

    PROCESS (ALL)
    BEGIN
        IF (memRead AND jump) THEN
            outFlags(2) <= dataMem(2);
            outFlags(1) <= dataMem(1);
            outFlags(0) <= dataMem(0);
        ELSE
            outFlags(1) <= aluNeg;
            outFlags(0) <= aluZero;
            IF (NOT aluOp(2) AND (aluOp(1) OR aluOp(0))) THEN
                outFlags(2) <= carryOld;
            ELSE
                IF (portEN AND flagEN) THEN
                    outFlags(2) <= aluSrc;
                ELSE
                    outFlags(2) <= aluCarry;
                END IF;
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;