LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
library work;
ENTITY UpdateSpCircuit IS
    PORT (
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIG_MemRead : IN STD_LOGIC;
        SIG_MemWrite : IN STD_LOGIC;
        SIG_ALUsrc : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SP_Modified : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY UpdateSpCircuit;


Architecture Behavioral of UpdateSpCircuit is
    begin
        process (all)
        begin
            if (SIG_jump and SIG_branch) then
                SP_Modified <= "0000001111111110";---------- For call/int which push 32bits to the stack
            else
                if (not SIG_MemRead and SIG_MemWrite and not SIG_ALUsrc) then
                    SP_Modified <= std_logic_vector(to_unsigned(to_integer((signed(SP)) - 2),16));
                elsif (SIG_MemRead and not SIG_MemWrite and not SIG_ALUsrc) then
                    --add 2 to SP
                    SP_Modified <= std_logic_vector(to_unsigned(to_integer((signed(SP)) + 2),16));
                else
                    SP_Modified <= SP;   
                    
                end if;
            end if;
        end process;
        
        
end architecture;