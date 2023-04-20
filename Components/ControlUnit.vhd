LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY ControlUnit IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIG_MemRead : OUT STD_LOGIC;
        SIG_MemWrite : OUT STD_LOGIC;
        SIG_ALUsrc : OUT STD_LOGIC;
        SIG_ALUop : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        SIG_MemToReg : OUT STD_LOGIC;
        SIG_Branch : OUT STD_LOGIC;
        SIG_Jump : OUT STD_LOGIC;
        SIG_RegDst : OUT STD_LOGIC;
        SIG_RegWrite : OUT STD_LOGIC;
        SIG_PortEN : OUT STD_LOGIC;
        SIG_FlagEN : OUT STD_LOGIC

    );

END ENTITY ControlUnit;
ARCHITECTURE Behavioral OF ControlUnit IS
    
BEGIN

    PROCESS (Instruction)
    BEGIN

        IF Instruction(31 DOWNTO 30) = "00" THEN
            --Instruction is I-Type
            SIG_Branch <= '0';
            SIG_Jump <= '0';
            SIG_RegDst <= '0';
            SIG_RegWrite <= Instruction(29);

            IF Instruction(29) = '0' THEN
                SIG_ALUsrc <= Instruction(26);
                SIG_ALUop <= (OTHERS => '0');
                Sig_MemToReg <= '0';
                Sig_MemRead <= '0';
                SIG_PortEN <= Instruction(28);
                IF Instruction(28) = '1' THEN
                    SIG_FlagEN <= INSTRUCTION(27);
                    SIG_Memwrite <= '0';
                ELSE
                    SIG_MemWrite <= Instruction(27);
                    SIG_FlagEN <= '0';
                END IF;
            ELSE
                SIG_MEMRead <= iNSTRUCTION(28);
                SIG_MEMWrite <= '0';
                SIG_ALUsrc <= Instruction(27);
                SIG_ALUop <= "000";
                SIG_memToReg <= iNSTRUCTION(28);
                sig_portEN <= instruction(26);
                IF instruction(28 DOWNTO 27) = "01" THEN
                    SIG_FlagEN <= '1';
                ELSE
                    SIG_FlagEN <= '0';
                END IF;
            END IF;
        ELSIF Instruction(31 DOWNTO 30) = "01" THEN
            --Instruction is R-Type
            SIG_MemRead <= '0';
            SIG_MemWrite <= '0';
            SIG_ALUsrc <= '0';
            SIG_MEMToReg <= '0';
            SIG_Branch <= '0';
            SIG_Jump <= '0';
            SIG_RegDst <= '1';
            SIG_RegWrite <= '1';
            SIG_PortEN <= '0';
            SIG_FlagEN <= Instruction(29);
            SIG_ALUop <= Instruction(16 DOWNTO 14);

        ELSIF Instruction(31 DOWNTO 30) = "10" THEN
            --Instruction is J-Type
            SIG_ALUsrc <= '0';
            SIG_MEMToReg <= '0';
            SIG_RegDst <= '0';
            SIG_RegWrite <= '0';
            SIG_PortEN <= '0';
            IF Instruction(29) = '0' THEN
                SIG_Branch <= '1';
                SIG_Jump <= '0';
                SIG_MEMRead <= '0';
                SIG_memWrite <= '0';
                SIG_FlagEN <= '0';
                SIG_aluop(2 DOWNTO 1) <= "00";
                SIG_ALUop(0) <= Instruction(28);
            ELSE
                SIG_Branch <= '0';
                SIG_Jump <= '1';
                SIG_MEMRead <= instruction(28);
                SIG_memWrite <= instruction(27);
                SIG_FlagEN <= instruction(26);
                SIG_aluop <= (OTHERS => '0');
            END IF;
        ELSE
            SIG_MemRead <= '0';
            SIG_MemWrite <= '0';
            SIG_ALUsrc <= '0';
            SIG_ALUop <= "000";
            SIG_MEMToReg <= '0';
            SIG_Branch <= '1';
            SIG_Jump <= '1';
            SIG_RegDst <= '0';
            SIG_RegWrite <= '0';
            SIG_PortEN <= '0';
            SIG_FlagEN <= '0';
        END IF;
    END PROCESS;

END ARCHITECTURE;