LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE IEEE.math_real.ALL;
ENTITY addressable_memory_tb IS
END ENTITY;

ARCHITECTURE sim OF addressable_memory_tb IS
    SIGNAL clk : STD_LOGIC := '0';
    SIGNAL reset : STD_LOGIC := '0';
    SIGNAL write_en : STD_LOGIC := '0';
    SIGNAL byte_addr : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL word_addr : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_in : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL data_out : STD_LOGIC_VECTOR(31 DOWNTO 0);

    CONSTANT WORD_SIZE : INTEGER := 32;
    CONSTANT MEM_SIZE : INTEGER := 1024;

    COMPONENT addressable_memory IS
        GENERIC (
            WORD_SIZE : INTEGER := 32;
            MEM_SIZE : INTEGER := 1024
        );
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            write_en : IN STD_LOGIC;
            byte_addr : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            word_addr : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(MEM_SIZE)))) - 1 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR(WORD_SIZE - 1 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR(WORD_SIZE - 1 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    dut : addressable_memory
    GENERIC MAP(
        WORD_SIZE => WORD_SIZE,
        MEM_SIZE => MEM_SIZE
    )
    PORT MAP(
        clk => clk,
        reset => reset,
        write_en => write_en,
        byte_addr => byte_addr,
        word_addr => word_addr,
        data_in => data_in,
        data_out => data_out
    );

    PROCESS
    BEGIN
        -- Initialize memory to all zeros
        FOR i IN 0 TO MEM_SIZE - 1 LOOP
            WAIT UNTIL rising_edge(clk);
            reset <= '1';
            WAIT UNTIL rising_edge(clk);
            reset <= '0';
            WAIT UNTIL rising_edge(clk);
        END LOOP;

        -- Write data to memory
        write_en <= '1';
        byte_addr <= "00";

        FOR i IN 0 TO MEM_SIZE - 1 LOOP
            WAIT UNTIL rising_edge(clk);
            word_addr <= STD_LOGIC_VECTOR(to_unsigned(i, word_addr'length));
            data_in <= STD_LOGIC_VECTOR(to_unsigned(i * 2, WORD_SIZE));
        END LOOP;

        write_en <= '0';

        -- Read data from memory
        byte_addr <= "00";

        FOR i IN 0 TO MEM_SIZE - 1 LOOP
            WAIT UNTIL rising_edge(clk);
            word_addr <= STD_LOGIC_VECTOR(to_unsigned(i, word_addr'length));
            ASSERT data_out = STD_LOGIC_VECTOR(to_unsigned(i * 2, WORD_SIZE))
            REPORT "Mismatch in read data at address " & INTEGER'image(i)
                SEVERITY error;
        END LOOP;

        byte_addr <= "01";

        FOR i IN 0 TO MEM_SIZE - 1 LOOP
            WAIT UNTIL rising_edge(clk);
            word_addr <= STD_LOGIC_VECTOR(to_unsigned(i, word_addr'length));
            ASSERT data_out = STD_LOGIC_VECTOR(to_unsigned(i * 2 + 1, WORD_SIZE/2))
            REPORT "Mismatch in read data (upper half-word) at address " & INTEGER'image(i)
                SEVERITY error;
        END LOOP;
        WAIT;
    END PROCESS;
END sim;