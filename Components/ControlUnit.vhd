LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
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


Architecture Behavioral of ControlUnit is
    begin

        process (Instruction)
        begin
            
        if Instruction(31 downto 30) = "00" then
            --Instruction is I-Type
            SIG_Branch <= '0';
            SIG_Jump <= '0';
            SIG_RegDst <= '0';
            SIG_RegWrite <= Instruction(29);
            
            if Instruction(29) = '0' then
                SIG_ALUsrc <= Instruction(26);
                SIG_ALUop <= (others => '0');
                Sig_MemToReg <= '0';
                Sig_MemRead <= '0';
                SIG_PortEN <= Instruction(28);
                if Instruction(28) = '1' then
                    SIG_FlagEN <= INSTRUCTION(27);
                    SIG_Memwrite <= '0';
                else
                    SIG_MemWrite <= Instruction(27);
                    SIG_FlagEN <= '0';
                end if;
            else 
                SIG_MEMRead <= iNSTRUCTION(28);
                SIG_MEMWrite <= '0';
                SIG_ALUsrc <= Instruction(27);  
                SIG_ALUop <= "001";
                SIG_memToReg <= iNSTRUCTION(28);
                sig_portEN <= instruction(26); 
                if instruction(28 downto 27) = "01" then
                    SIG_FlagEN <= '1';
                else
                    SIG_FlagEN <= '0';
                end if;
            end if;
        elsif Instruction(31 downto 30) = "01" then
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
            SIG_ALUop <= Instruction(16 downto 14);
            
        elsif Instruction(31 downto 30) = "10" then
            --Instruction is J-Type
            SIG_ALUsrc <= '0';
            SIG_MEMToReg <= '0';
            SIG_RegDst <= '0';
            SIG_RegWrite <= '0';
            SIG_PortEN <= '0';
            if Instruction(29) = '0' then
                SIG_Branch <= '1';
                SIG_Jump <= '0';
                SIG_MEMRead <= '0';
                SIG_memWrite <= '0';
                SIG_FlagEN <= '0';
                SIG_aluop(2 downto 1) <= "00";
                SIG_ALUop(0) <= Instruction(28);
            else
                SIG_Branch <= '0';
                SIG_Jump <= '1';
                SIG_MEMRead <= instruction(28);
                SIG_memWrite <= instruction(27);
                SIG_FlagEN <= instruction(26);
                SIG_aluop <= (others => '0'); 
            end if;
        end if;
        end process;
        
end architecture;