LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
library work;
ENTITY Decoder_1x2 IS
    GENERIC (
        WIDTH : INTEGER := 1
    );
    PORT (
        sel : IN STD_LOGIC;
        input : IN STD_LOGIC_VECTOR(WIDTH - 1 DOWNTO 0);
        output_a : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0);
        output_b : OUT STD_LOGIC_VECTOR(width - 1 DOWNTO 0)
    );
END ENTITY Decoder_1x2;

ARCHITECTURE rtl OF Decoder_1x2 IS
BEGIN
    main : PROCESS (ALL)
    BEGIN
        IF sel = '0' THEN
            output_a <= input;
            output_b <= (OTHERS => '0');
        ELSE
            output_a <= (OTHERS => '0');
            output_b <= input;
        END IF;
    END PROCESS main;
END ARCHITECTURE rtl;