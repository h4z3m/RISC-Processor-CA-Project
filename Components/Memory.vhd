LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY Memory IS
    PORT (
        WriteData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ReadData : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteEnable : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        ReadAddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Memory;