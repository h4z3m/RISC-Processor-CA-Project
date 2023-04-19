
LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY ALU IS
    PORT (
        Opcode : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Operand_1 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Operand_2 : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Output : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        CARRY : OUT STD_LOGIC;
        ZERO : OUT STD_LOGIC;
        NEGATIVE : OUT STD_LOGIC
    );
END ALU;

architecture ALU_IMP OF ALU is
        signal temp_output: STD_LOGIC_VECTOR(16 DOWNTO 0);
        begin
        process(all)
        variable operand1_int : integer;
        variable operand2_int : integer;
        variable output_int : integer;
        begin

        case Opcode is 
        when "000" => -- NOP
        Output <= Operand_1;
        ZERO <= '0';
        CARRY <= '0';
        NEGATIVE <= '0';

        when "111" => -- INC
	operand1_int := to_integer(signed(Operand_1));
	output_int := operand1_int + 1;
        temp_output <= std_logic_vector(to_signed(output_int,17));
        Output <= std_logic_vector(to_signed(output_int,16));
        CARRY <= '1' when temp_output(16) = '1' else '0';
        ZERO <= '1' when to_integer(signed(Output)) = 0 else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "100" => -- ADD
	operand1_int := to_integer(signed(Operand_1));
        operand2_int := to_integer(signed(Operand_2));
	output_int := operand1_int + operand2_int;
        temp_output <= std_logic_vector(to_signed(output_int,17));
        Output <= std_logic_vector(to_signed(output_int,16));
        CARRY <= '1' when temp_output(16) = '1' else '0';
        ZERO <= '1' when to_integer(signed(Output)) = 0 else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "101" => -- SUB
	operand1_int := to_integer(signed(Operand_1));
        operand2_int := to_integer(signed(Operand_2));
	output_int := operand1_int - operand2_int;
        temp_output <= std_logic_vector(to_unsigned(output_int,17));
        Output <= temp_output(15 downto 0);
        CARRY <= '1' when temp_output(16) = '1' else '0';
        ZERO <= '1' when to_integer(signed(Output)) = 0 else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "110" => -- DEC
	operand1_int := to_integer(signed(Operand_1));
	output_int := operand1_int - 1;
        temp_output <= std_logic_vector(to_unsigned(output_int,17));
        Output <= temp_output(15 downto 0);
        CARRY <= '1' when temp_output(16) = '1' else '0';
        ZERO <= '1' when to_integer(signed(Output)) = 0 else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "001" => -- AND
        Output <= Operand_1 and Operand_2;
        CARRY <= '0';
        ZERO <= '1' when Output = "0000000000000000" else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "010" => -- OR
        Output <= Operand_1 or Operand_2;
        CARRY <= '0';
        ZERO <= '1' when Output = "0000000000000000" else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when "011" => -- NOT
        Output <= not Operand_1;
        CARRY <= '0';
        ZERO <= '1' when Output = "0000000000000000" else '0';
        NEGATIVE <= '1' when Output(15) = '1' else '0';

        when others => -- Garbage
        Output <= (others => '0');
        CARRY <= '0';
        ZERO <= '0';
        NEGATIVE <= '0';
        
        end case;

        end process;
        end architecture ALU_IMP;
        
        

