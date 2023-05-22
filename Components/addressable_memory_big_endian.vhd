LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;
LIBRARY work;
---- Addressable memory (BIG-ENDIAN)

-- Description : Addressable memory which can be read AND written TO depending ON the mode input which selects between
-- the following modes :
-- 00 -> Read/write entire word at the given address
-- 01 -> Read/write 2 words starting at the given address

ENTITY addressable_memory_big_endian IS
    GENERIC (
        WORD_SIZE : INTEGER := 16;
        MEM_SIZE : INTEGER := 512
    );
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        write_en : IN STD_LOGIC;

        -- Modes available:
        -- 00 -> Read/write entire word at the given address
        -- 01 -> Read/write 2 words starting at the given address

        -- Examples assuming word size is 16 bits.

        ------- Writing examples
        -- Example:
        -- addr=00, data_in = abcd1234, mode=01 -> Write 2 words
        -- Mem[00] = 1234
        -- Mem[01] = abcd

        -- Example:
        -- addr=0A, data_in = abcd1234, mode = 00 -> Write 1 word
        -- Mem[0A] = 1234
        -- Mem[0B] = ???? (unchanged)

        ------- Reading examples
        -- Example:
        -- addr=00, mode = 01 -> Read 2 words
        -- Assume M[00] = 1234, M[01] = abcd
        -- data_out (31 downto 16) = abcd
        -- data_out (15 downto 0) = 1234

        -- Example:
        -- addr=00, mode = 00 -> Read 1 words
        -- Assume M[00] = 1234, M[01] = abcd
        -- data_out (31 downto 16) = 0000
        -- data_out (15 downto 0) = 1234
        mode : IN STD_LOGIC;
        word_addr : IN STD_LOGIC_VECTOR(INTEGER(ceil(log2(real(MEM_SIZE)))) - 1 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR(WORD_SIZE * 2 - 1 DOWNTO 0);
        data_out : OUT STD_LOGIC_VECTOR(WORD_SIZE * 2 - 1 DOWNTO 0)
    );
END ENTITY;

ARCHITECTURE rtl OF addressable_memory_big_endian IS
    TYPE mem_array IS ARRAY(NATURAL RANGE <>) OF STD_LOGIC_VECTOR(WORD_SIZE - 1 DOWNTO 0);
    SIGNAL memory : mem_array(0 TO MEM_SIZE - 1); -- Addressable memory up to MEM_SIZE words
BEGIN
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF reset = '1' THEN
                memory <= (OTHERS => (OTHERS => '0'));
            ELSIF write_en = '1' THEN
                IF mode = '0' THEN -- Write 1 word (16 bits)
                    memory(to_integer(unsigned(word_addr))) <= data_in(WORD_SIZE - 1 DOWNTO 0);
                ELSE -- Write 2 words (16 bits per cell, total 32 bits)
                    memory(to_integer(unsigned(word_addr)) + 1) <= data_in(WORD_SIZE - 1 DOWNTO 0);
                    memory(to_integer(unsigned(word_addr))) <= data_in(WORD_SIZE * 2 - 1 DOWNTO WORD_SIZE);
                END IF;
            END IF;
            -- IF mode = '0' THEN -- Read 1 word into most significant half-word, pad the rest with zeros
            --     data_out(WORD_SIZE * 2 - 1 DOWNTO WORD_SIZE) <= (OTHERS => '0');
            --     data_out(WORD_SIZE - 1 DOWNTO 0) <= memory(to_integer(unsigned(word_addr)));
            -- ELSE -- Read 2 words 
            --     data_out(WORD_SIZE * 2 - 1 DOWNTO WORD_SIZE) <= memory(to_integer(unsigned(word_addr)));
            --     data_out(WORD_SIZE - 1 DOWNTO 0) <= memory(to_integer(unsigned(word_addr)) + 1);
            -- END IF;
        END IF;
    END PROCESS;
    data_out(WORD_SIZE * 2 - 1 DOWNTO WORD_SIZE) <= (OTHERS => '0') WHEN mode = '0' ELSE
    memory(to_integer(unsigned(word_addr)));
    
    data_out(WORD_SIZE - 1 DOWNTO 0) <= memory(to_integer(unsigned(word_addr))) WHEN mode = '0' ELSE
    memory(to_integer(unsigned(word_addr)) + 1);

END ARCHITECTURE;