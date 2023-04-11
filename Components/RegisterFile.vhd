LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY RegisterFile IS
    PORT (

        WriteEnable : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
        WriteAddr : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        ReadAddr2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

        WriteData : IN STD_LOGIC_VECTOR(15 DOWNTO 0);

        ReadData1 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        ReadData2 : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );
END ENTITY;