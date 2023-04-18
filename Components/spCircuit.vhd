LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY spCircuit IS
    PORT (
        SP : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        SIG_MemRead : OUT STD_LOGIC;
        SIG_MemWrite : OUT STD_LOGIC;
        SIG_ALUsrc : OUT STD_LOGIC;
        SIG_Branch : OUT STD_LOGIC;
        SIG_Jump : OUT STD_LOGIC;
        SP_Modified : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY spCircuit;


Architecture Behavioral of spCircuit is
    begin
        process (all)
        begin
            if (SIG_jump and SIG_branch) then
                SP_Modified <= "0000001111111111";
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