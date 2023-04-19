LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
library work;
LIBRARY ieee;
USE ieee.std_logic_1164;
PACKAGE commons IS
    CONSTANT PER : TIME := 50 ns;
    SUBTYPE byte IS STD_LOGIC_VECTOR(7 DOWNTO 0);
    CONSTANT CLEARS : byte := "00000000";
    PROCEDURE dff(SIGNAL Rst, Clk : IN STD_LOGIC; SIGNAL D : IN byte;
    SIGNAL Q : OUT byte);
END commons;
