LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY ControlUnit IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIG_MemRead : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_MemWrite : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_ALUsrc : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_ALUop : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_MemToReg : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_Branch : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_Jump : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_RegDst : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_RegWrite : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_PortEN : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
        SIG_FlagEN : OUT STD_LOGIC_VECTOR(0 DOWNTO 0)

    );
END ENTITY ControlUnit;