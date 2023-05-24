
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY ALU IS
        PORT (
                Opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
                Operand_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                Operand_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
                Result : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
                CARRY : OUT STD_LOGIC;
                ZERO : OUT STD_LOGIC;
                NEGATIVE : OUT STD_LOGIC
        );
END ALU;

ARCHITECTURE ALU_IMP OF ALU IS
        SIGNAL temp_output : STD_LOGIC_VECTOR(16 DOWNTO 0);
        SIGNAL temppp : STD_LOGIC_VECTOR(16 DOWNTO 0);
BEGIN
        PROCESS (ALL)
                VARIABLE operand1_int : INTEGER;
                VARIABLE operand2_int : INTEGER;
                VARIABLE output_int : INTEGER;
        BEGIN

                IF Opcode = "000" THEN -- NOP
                        Result <= Operand_1;
                        ZERO <= '0';
                        CARRY <= '0';
                        NEGATIVE <= '0';
                        temp_output <= (OTHERS => '0');
                        temppp <= (OTHERS => '0');

                ELSIF Opcode = "111" THEN -- INC

                        operand1_int := to_integer(signed(Operand_1));
                        output_int := operand1_int + 1;
                        temp_output <= STD_LOGIC_VECTOR(to_unsigned(output_int, 17));
                        temppp <= ('0' & Operand_1) + ("00000000000000001");
                        -- Output <= STD_LOGIC_VECTOR(to_signed(output_int, 16));
                        Result <= temppp(15 DOWNTO 0);
                        -- temp_output <= temppp;
                        REPORT "Result = " & to_string(Result);
                        REPORT "Tempp=" & to_string(temppp);
                        IF temppp(16) = '1' THEN
                                CARRY <= '1';
                        ELSE
                                carry <= '0';
                        END IF;

                        IF Result = "0000000000000000"THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;

                ELSIF Opcode = "100" THEN -- ADD

                        operand1_int := to_integer(signed(Operand_1));
                        operand2_int := to_integer(signed(Operand_2));
                        output_int := operand1_int + operand2_int;
                        -- temp_output <= STD_LOGIC_VECTOR(to_unsigned(output_int, 17));
                        -- Output <= STD_LOGIC_VECTOR(to_signed(output_int, 16));

                        temppp <= ('0' & Operand_1) + (Operand_2);
                        carry <= temppp(16);
                        Result <= temppp(15 DOWNTO 0);
                        -- temp_output <= temppp;
                        IF temppp(16) = '1' THEN
                                CARRY <= '1';
                        ELSE
                                carry <= '0';
                        END IF;

                        IF Result = "0000000000000000" THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;
                ELSIF Opcode = "101" THEN -- SUB

                        operand1_int := to_integer(signed(Operand_1));
                        operand2_int := to_integer(signed(Operand_2));
                        output_int := operand1_int - operand2_int;
                        -- temp_output <= STD_LOGIC_VECTOR(to_unsigned(output_int, 17));
                        -- Output <= temp_output(15 DOWNTO 0);

                        ---------------------------------------------------
                        temppp <= ('0' & Operand_1) - (Operand_2);
                        carry <= temppp(16);
                        Result <= temppp(15 DOWNTO 0);
                        -- temp_output <= temppp;
                        ---------------------------------------------------
                        IF temppp(16) = '1' THEN
                                CARRY <= '1';
                        ELSE
                                carry <= '0';
                        END IF;

                        IF Result = "0000000000000000" THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;

                ELSIF Opcode = "110" THEN -- DEC

                        operand1_int := to_integer(signed(Operand_1));
                        output_int := operand1_int - 1;
                        -- temp_output <= STD_LOGIC_VECTOR(to_unsigned(output_int, 17));
                        -- Output <= temp_output(15 DOWNTO 0);

                        ---------------------------------------------------
                        temppp <= ('0' & Operand_1) - ("00000000000000001");
                        carry <= temppp(16);
                        Result <= temppp(15 DOWNTO 0);
                        -- temp_output <= temppp;
                        ---------------------------------------------------

                        IF temppp(16) = '1' THEN
                                CARRY <= '1';
                        ELSE
                                carry <= '0';
                        END IF;

                        IF Result = "0000000000000000"THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;

                ELSIF Opcode = "001" THEN -- AND

                        Result <= Operand_1 AND Operand_2;
                        temp_output <= (OTHERS => '0');
                        temppp <= (OTHERS => '0');

                        CARRY <= '0';
                        IF Result = "0000000000000000" THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;
                ELSIF Opcode = "010" THEN -- OR

                        Result <= Operand_1 OR Operand_2;
                        temp_output <= (OTHERS => '0');
                        temppp <= (OTHERS => '0');

                        CARRY <= '0';
                        IF Result = "0000000000000000" THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;
                ELSIF Opcode = "011" THEN -- NOT
                        temp_output <= (OTHERS => '0');
                        temppp <= (OTHERS => '0');

                        Result <= NOT Operand_1;
                        CARRY <= '0';
                        IF Result = "0000000000000000" THEN
                                ZERO <= '1';
                        ELSE
                                ZERO <= '0';
                        END IF;
                        IF Result(15) = '1' THEN
                                NEGATIVE <= '1';
                        ELSE
                                NEGATIVE <= '0';
                        END IF;
                ELSE
                        temp_output <= (OTHERS => '0');
                        temppp <= (OTHERS => '0');
                        Result <= (OTHERS => '0');
                        CARRY <= '0';
                        ZERO <= '0';
                        NEGATIVE <= '0';

                END IF;
        END PROCESS;
END ARCHITECTURE ALU_IMP;