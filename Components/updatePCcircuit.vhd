LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
library work;
ENTITY updatePCcircuit IS
    PORT (
        rdst : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC_Return_Stack : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Flag_en : IN STD_LOGIC;
        SIG_MemWrite : IN STD_LOGIC;
        SIG_MemRead : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SIG_AluOP0 : IN STD_LOGIC;
        Zero_flag : IN STD_LOGIC;
        Carry_flag : IN STD_LOGIC;
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)

    );

END ENTITY updatePCcircuit;


Architecture Behavioral of updatePCcircuit is
    begin
        process (all)
        begin
            if (SIG_Branch and SIG_Jump) then
                PC_out <= (others => '0') ;
            elsif (SIG_Branch and not SIG_Jump) then
                if ((Sig_aluop0 and carry_flag) or (not Sig_aluop0 and Zero_flag)) then
                    PC_out <= rdst;
                else
                    pc_out <= std_logic_vector(to_unsigned(to_integer((signed(pc)) + 2),16));                    
                end if;
            elsif (SIG_Jump and not SIG_Branch) then
                if (SIG_MemRead) then
                    pc_out <= PC_Return_Stack;
                elsif (flag_en) then
                    pc_out <= "0000000000000001";
                else
                    pc_out <= rdst;
                end if;
            else
                pc_out <= std_logic_vector(to_unsigned(to_integer((signed(pc)) + 2),16));
            
            end if;
        end process;
        
        
end architecture;