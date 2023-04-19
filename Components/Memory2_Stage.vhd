ENTITY Memory2_Stage IS
    PORT (
        clk : IN STD_LOGIC;
        ---Memory
        DataMemory_ReadAddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        SIG_MemWrite : IN STD_LOGIC;
        Write_enable : IN STD_LOGIC;

        ---- UPDATE PC
        SIG_MemRead : IN STD_LOGIC;
        SIG_Branch : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        SIG_ALUop : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        Zero_flag : IN STD_LOGIC;
        Carry_flag : IN STD_LOGIC;
        Flag_en : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);


        ----INPUT PORT
        Input_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Input_enable : IN STD_LOGIC;
        
        Input_port_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)


        --Write_Back_Address
    );
END ENTITY Memory2_Stage;

ARCHITECTURE rtl OF ent IS
    SIGNAL RDST : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    UpdateProgramCounter : ENTITY WORK.UpdatePCcircuit PORT MAP (
        PC => PC,
        Flag_en => Flag_en,
        SIG_MemRead => SIG_MemRead,
        SIG_Branch => SIG_Branch,
        SIG_Jump => SIG_Jump,
        SIG_AluOP0 => Sig_aluop(0),
        Zero_flag => Zero_flag,
        Carry_flag => Carry_flag,
        PC_Return_Stack 
        PC_out => PC_out,
        rdst => RDST(31 downto 16)
        );
    Data_Memory : ENTITY work.Memory GENERIC MAP (
        32, 1024
        ) PORT MAP (
        ReadAddr => DataMemory_ReadAddr,
        ReadData => RDST,
        we => Write_enable,
        clk => clk,
        WriteData => WriteData
        );
    input_port_inst : ENTITY work.INPUT_PORT
        GENERIC MAP(
            16
        )
        PORT MAP(
            in_value => Input_value,
            enable => Input_enable,
            port_value => Input_port_value
        );
END ARCHITECTURE;