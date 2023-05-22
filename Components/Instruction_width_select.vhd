LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY Instruction_width_select IS
    PORT (
        Instruction : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        types : IN STD_LOGIC_VECTOR (1 DOWNTO 0);

        Instruction_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );

END ENTITY Instruction_width_select;
ARCHITECTURE Behavioral OF Instruction_width_select IS
BEGIN
    PROCESS (types, instruction)
    BEGIN

        IF (Instruction(31 DOWNTO 16) = "0000000000000000") THEN
            Instruction_out <= (OTHERS => '0');
        ELSIF (types = "00") THEN
            Instruction_out <= Instruction;
        ELSE
            Instruction_out <= Instruction(31 DOWNTO 16) & "0000000000000000";

        END IF;
    END PROCESS;

END ARCHITECTURE;