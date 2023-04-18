library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity UpdateFlagRegister is
    port(
        clk: in std_logic;
        reset: in std_logic;
        -- Control Signals --
        flagEN: in std_logic;
        aluSrc: in std_logic;
        portEN: in std_logic;
        jump: in std_logic;
        memRead: in std_logic;
        aluOp: in std_logic_vector(7 downto 0);
        -- Alu Data --
        aluCarry: in std_logic;
        aluNeg: in std_logic;
        aluZero: in std_logic;
        
        -- Output --
        carryFlag: out std_logic;
        NegFlag: out std_logic;
        ZeroFlag: out std_logic;
    );
end UpdateFlagRegister;


Architecture Behavioral of ControlUnit is
    begin

        process (all)
        begin
            if(reset) then
                carryFlag <= '0';
                NegFlag <= '0';
                ZeroFlag <= '0';
            end if;
        end process;
        
end architecture;