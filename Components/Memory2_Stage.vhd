LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
LIBRARY work;
ENTITY Memory2_Stage IS
    PORT (
        clk : IN STD_LOGIC;
        ---Memory
        DataMemory_ReadAddr : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataMemory_Mode : IN STD_LOGIC;
        WriteData : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_enable : IN STD_LOGIC;

        ---- UPDATE PC
        SIG_MemRead : IN STD_LOGIC;
        SIG_MemToReg : IN STD_LOGIC;
        SIG_Jump : IN STD_LOGIC;
        Flag_en : IN STD_LOGIC;
        Port_en : IN STD_LOGIC;
        PC : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ----INPUT PORT
        Input_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        Input_enable : IN STD_LOGIC;
        Immediate_value : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        ALU_Result : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- Outputs
        PC_out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        -- PC_Mux_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        Write_data_RDST : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        Input_port_value : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        DataMemory_Return_FlagRegister_Out : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        DataMemory_Return_PC_Out : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY Memory2_Stage;

ARCHITECTURE rtl OF Memory2_Stage IS
    SIGNAL RDST : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Decoder_out_0 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL Decoder_out_1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL After_memory_mux_2x1_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL input_port_reading : STD_LOGIC_VECTOR(15 DOWNTO 0);
BEGIN
    -- PC_Mux_out <= Decoder_out_0;

    addressable_memory_inst : ENTITY work.addressable_memory
        GENERIC MAP(
            WORD_SIZE => 16,
            MEM_SIZE => 1024
        )
        PORT MAP(
            clk => clk,
            reset => '0',
            write_en => Write_enable,
            mode => DataMemory_Mode,
            word_addr => DataMemory_ReadAddr(9 DOWNTO 0),
            data_in => WriteData,
            data_out => RDST
        );

    input_port_reading <= Input_port_value;

    MUX_4x1 : ENTITY work.MUX_4x1 GENERIC MAP(16)
        PORT MAP(
            in0 => Immediate_value,
            in1 => Decoder_out_1(31 DOWNTO 16),
            in2 => input_port_reading,
            in3 => (OTHERS => '0'),
            sel => (port_en & (sig_memtoreg OR flag_en)),
            out1 => Write_data_RDST
        );

    input_port_inst : ENTITY work.INPUT_PORT GENERIC MAP(16)
        PORT MAP(
            in_value => Input_value,
            enable => Input_enable,
            port_value => Input_port_value
        );
    Decoder : ENTITY work.Decoder_1x2 GENERIC MAP(32)
        PORT MAP(
            sel => (SIG_Jump AND SIG_MemRead),
            input => After_memory_mux_2x1_out,
            output_a => Decoder_out_1,
            output_b => Decoder_out_0
        );
    After_memory_mux_2x1 : ENTITY work.MUX GENERIC MAP(16)
        PORT MAP(
            in0 => ALU_Result,
            in1 => RDST(15 DOWNTO 0),
            sel => SIG_MemToReg,
            out1 => After_memory_mux_2x1_out(31 DOWNTO 16)
        );
    DataMemory_Return_PC_Out <= After_memory_mux_2x1_out(15 DOWNTO 0);
    DataMemory_Return_FlagRegister_Out <= After_memory_mux_2x1_out(18 DOWNTO 16);
END ARCHITECTURE;