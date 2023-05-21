LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY InstructionCache IS
    GENERIC (
        WORD_SIZE : INTEGER := 16;
        MEM_SIZE : INTEGER := 1024
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        pc : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        valid : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE rtl OF InstructionCache IS
    SIGNAL addr : STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(MEM_SIZE)))) - 1 DOWNTO 0);
    SIGNAL data : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr_length : INTEGER RANGE 1 TO 2;
    SIGNAL new_pc : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    memory : ENTITY work.addressable_memory
        GENERIC MAP(
            WORD_SIZE => WORD_SIZE,
            MEM_SIZE => MEM_SIZE
        )
        PORT MAP(
            clk => clk,
            reset => reset,
            write_en => '0',
            mode => '1',
            word_addr => addr,
            data_in => (OTHERS => '0'),
            data_out => data
        );
    -- Determine the length of the current instruction
    PROCESS (data)
    BEGIN
        IF data(31) = "0" AND data(30) = '0' THEN
            instr_length <= 2;
            instruction <= data;
        ELSE
            instr_length <= 1;
            instruction <= data(WORD_SIZE - 1 DOWNTO 0) & "0000000000000000";
        END IF;
    END PROCESS;

    -- Increment the program counter by the length of the current instruction
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            new_pc <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF instr_length = 2 THEN
                new_pc <= STD_LOGIC_VECTOR(unsigned(pc) + 2);
            ELSE
                new_pc <= STD_LOGIC_VECTOR(unsigned(pc) + 1);
            END IF;
        END IF;
    END PROCESS;

    -- Check if the current instruction is valid
    valid <= '1' WHEN instr_length > 1 ELSE
        '0';

    -- Set the address input of the memory to the current program counter
    addr <= STD_LOGIC_VECTOR(to_unsigned(unsigned(pc), addr'length));
END ARCHITECTURE;