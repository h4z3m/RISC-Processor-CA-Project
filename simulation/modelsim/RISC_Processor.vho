-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- VENDOR "Altera"
-- PROGRAM "Quartus Prime"
-- VERSION "Version 20.1.1 Build 720 11/11/2020 SJ Lite Edition"

-- DATE "05/21/2023 17:54:27"

-- 
-- Device: Altera 5CGXFC7C7F23C8 Package FBGA484
-- 

-- 
-- This VHDL file should be used for ModelSim (VHDL) only
-- 

LIBRARY ALTERA_LNSIM;
LIBRARY CYCLONEV;
LIBRARY IEEE;
USE ALTERA_LNSIM.ALTERA_LNSIM_COMPONENTS.ALL;
USE CYCLONEV.CYCLONEV_COMPONENTS.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY 	RISC_CPU IS
    PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	interrupt : IN std_logic;
	in_port : IN std_logic_vector(15 DOWNTO 0);
	out_port : BUFFER std_logic_vector(15 DOWNTO 0);
	INPUT_PORT_VALUE : BUFFER std_logic_vector(15 DOWNTO 0)
	);
END RISC_CPU;

-- Design Ports Information
-- clk	=>  Location: PIN_AA15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_AA22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- interrupt	=>  Location: PIN_P18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[0]	=>  Location: PIN_AA13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[1]	=>  Location: PIN_U16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[2]	=>  Location: PIN_U7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[3]	=>  Location: PIN_U15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[4]	=>  Location: PIN_H13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[5]	=>  Location: PIN_T13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[6]	=>  Location: PIN_D19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[7]	=>  Location: PIN_C6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[8]	=>  Location: PIN_AA9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[9]	=>  Location: PIN_H21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[10]	=>  Location: PIN_C11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[11]	=>  Location: PIN_AA12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[12]	=>  Location: PIN_A17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[13]	=>  Location: PIN_B20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[14]	=>  Location: PIN_D12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- in_port[15]	=>  Location: PIN_G16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[0]	=>  Location: PIN_E20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[1]	=>  Location: PIN_E12,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[2]	=>  Location: PIN_E15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[3]	=>  Location: PIN_J9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[4]	=>  Location: PIN_C20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[5]	=>  Location: PIN_T18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[6]	=>  Location: PIN_H11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[7]	=>  Location: PIN_AA20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[8]	=>  Location: PIN_B11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[9]	=>  Location: PIN_F22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[10]	=>  Location: PIN_R15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[11]	=>  Location: PIN_AB11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[12]	=>  Location: PIN_H9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[13]	=>  Location: PIN_C15,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[14]	=>  Location: PIN_D22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- out_port[15]	=>  Location: PIN_T9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[0]	=>  Location: PIN_P9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[1]	=>  Location: PIN_P8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[2]	=>  Location: PIN_F13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[3]	=>  Location: PIN_A10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[4]	=>  Location: PIN_G21,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[5]	=>  Location: PIN_AA14,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[6]	=>  Location: PIN_A9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[7]	=>  Location: PIN_B16,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[8]	=>  Location: PIN_F19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[9]	=>  Location: PIN_B10,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[10]	=>  Location: PIN_R5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[11]	=>  Location: PIN_R6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[12]	=>  Location: PIN_U8,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[13]	=>  Location: PIN_G6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[14]	=>  Location: PIN_P19,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- INPUT_PORT_VALUE[15]	=>  Location: PIN_T12,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF RISC_CPU IS
SIGNAL gnd : std_logic := '0';
SIGNAL vcc : std_logic := '1';
SIGNAL unknown : std_logic := 'X';
SIGNAL devoe : std_logic := '1';
SIGNAL devclrn : std_logic := '1';
SIGNAL devpor : std_logic := '1';
SIGNAL ww_devoe : std_logic;
SIGNAL ww_devclrn : std_logic;
SIGNAL ww_devpor : std_logic;
SIGNAL ww_clk : std_logic;
SIGNAL ww_reset : std_logic;
SIGNAL ww_interrupt : std_logic;
SIGNAL ww_in_port : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_out_port : std_logic_vector(15 DOWNTO 0);
SIGNAL ww_INPUT_PORT_VALUE : std_logic_vector(15 DOWNTO 0);
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \interrupt~input_o\ : std_logic;
SIGNAL \in_port[0]~input_o\ : std_logic;
SIGNAL \in_port[1]~input_o\ : std_logic;
SIGNAL \in_port[2]~input_o\ : std_logic;
SIGNAL \in_port[3]~input_o\ : std_logic;
SIGNAL \in_port[4]~input_o\ : std_logic;
SIGNAL \in_port[5]~input_o\ : std_logic;
SIGNAL \in_port[6]~input_o\ : std_logic;
SIGNAL \in_port[7]~input_o\ : std_logic;
SIGNAL \in_port[8]~input_o\ : std_logic;
SIGNAL \in_port[9]~input_o\ : std_logic;
SIGNAL \in_port[10]~input_o\ : std_logic;
SIGNAL \in_port[11]~input_o\ : std_logic;
SIGNAL \in_port[12]~input_o\ : std_logic;
SIGNAL \in_port[13]~input_o\ : std_logic;
SIGNAL \in_port[14]~input_o\ : std_logic;
SIGNAL \in_port[15]~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_reset <= reset;
ww_interrupt <= interrupt;
ww_in_port <= in_port;
out_port <= ww_out_port;
INPUT_PORT_VALUE <= ww_INPUT_PORT_VALUE;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X76_Y81_N36
\out_port[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(0));

-- Location: IOOBUF_X50_Y81_N59
\out_port[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(1));

-- Location: IOOBUF_X66_Y81_N42
\out_port[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(2));

-- Location: IOOBUF_X36_Y81_N2
\out_port[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(3));

-- Location: IOOBUF_X86_Y81_N36
\out_port[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(4));

-- Location: IOOBUF_X89_Y4_N45
\out_port[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(5));

-- Location: IOOBUF_X52_Y81_N2
\out_port[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(6));

-- Location: IOOBUF_X62_Y0_N36
\out_port[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(7));

-- Location: IOOBUF_X50_Y81_N93
\out_port[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(8));

-- Location: IOOBUF_X82_Y81_N93
\out_port[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(9));

-- Location: IOOBUF_X89_Y6_N22
\out_port[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(10));

-- Location: IOOBUF_X38_Y0_N36
\out_port[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(11));

-- Location: IOOBUF_X36_Y81_N19
\out_port[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(12));

-- Location: IOOBUF_X62_Y81_N2
\out_port[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(13));

-- Location: IOOBUF_X80_Y81_N53
\out_port[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(14));

-- Location: IOOBUF_X30_Y0_N19
\out_port[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_out_port(15));

-- Location: IOOBUF_X40_Y0_N19
\INPUT_PORT_VALUE[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(0));

-- Location: IOOBUF_X28_Y0_N19
\INPUT_PORT_VALUE[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(1));

-- Location: IOOBUF_X58_Y81_N59
\INPUT_PORT_VALUE[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(2));

-- Location: IOOBUF_X36_Y81_N36
\INPUT_PORT_VALUE[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(3));

-- Location: IOOBUF_X88_Y81_N20
\INPUT_PORT_VALUE[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(4));

-- Location: IOOBUF_X52_Y0_N53
\INPUT_PORT_VALUE[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(5));

-- Location: IOOBUF_X36_Y81_N53
\INPUT_PORT_VALUE[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(6));

-- Location: IOOBUF_X72_Y81_N36
\INPUT_PORT_VALUE[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(7));

-- Location: IOOBUF_X76_Y81_N2
\INPUT_PORT_VALUE[8]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(8));

-- Location: IOOBUF_X34_Y81_N42
\INPUT_PORT_VALUE[9]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(9));

-- Location: IOOBUF_X2_Y0_N42
\INPUT_PORT_VALUE[10]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(10));

-- Location: IOOBUF_X2_Y0_N59
\INPUT_PORT_VALUE[11]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(11));

-- Location: IOOBUF_X2_Y0_N76
\INPUT_PORT_VALUE[12]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(12));

-- Location: IOOBUF_X26_Y81_N42
\INPUT_PORT_VALUE[13]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(13));

-- Location: IOOBUF_X89_Y9_N39
\INPUT_PORT_VALUE[14]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(14));

-- Location: IOOBUF_X52_Y0_N19
\INPUT_PORT_VALUE[15]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_INPUT_PORT_VALUE(15));

-- Location: IOIBUF_X54_Y0_N35
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: IOIBUF_X64_Y0_N35
\reset~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: IOIBUF_X89_Y9_N55
\interrupt~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_interrupt,
	o => \interrupt~input_o\);

-- Location: IOIBUF_X52_Y0_N35
\in_port[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(0),
	o => \in_port[0]~input_o\);

-- Location: IOIBUF_X72_Y0_N18
\in_port[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(1),
	o => \in_port[1]~input_o\);

-- Location: IOIBUF_X2_Y0_N92
\in_port[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(2),
	o => \in_port[2]~input_o\);

-- Location: IOIBUF_X60_Y0_N1
\in_port[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(3),
	o => \in_port[3]~input_o\);

-- Location: IOIBUF_X56_Y81_N1
\in_port[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(4),
	o => \in_port[4]~input_o\);

-- Location: IOIBUF_X52_Y0_N1
\in_port[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(5),
	o => \in_port[5]~input_o\);

-- Location: IOIBUF_X86_Y81_N18
\in_port[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(6),
	o => \in_port[6]~input_o\);

-- Location: IOIBUF_X30_Y81_N35
\in_port[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(7),
	o => \in_port[7]~input_o\);

-- Location: IOIBUF_X32_Y0_N35
\in_port[8]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(8),
	o => \in_port[8]~input_o\);

-- Location: IOIBUF_X88_Y81_N2
\in_port[9]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(9),
	o => \in_port[9]~input_o\);

-- Location: IOIBUF_X50_Y81_N75
\in_port[10]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(10),
	o => \in_port[10]~input_o\);

-- Location: IOIBUF_X40_Y0_N35
\in_port[11]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(11),
	o => \in_port[11]~input_o\);

-- Location: IOIBUF_X74_Y81_N58
\in_port[12]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(12),
	o => \in_port[12]~input_o\);

-- Location: IOIBUF_X86_Y81_N52
\in_port[13]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(13),
	o => \in_port[13]~input_o\);

-- Location: IOIBUF_X50_Y81_N41
\in_port[14]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(14),
	o => \in_port[14]~input_o\);

-- Location: IOIBUF_X70_Y81_N52
\in_port[15]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_in_port(15),
	o => \in_port[15]~input_o\);

-- Location: LABCELL_X1_Y48_N3
\~QUARTUS_CREATED_GND~I\ : cyclonev_lcell_comb
-- Equation(s):

-- pragma translate_off
GENERIC MAP (
	extended_lut => "off",
	lut_mask => "0000000000000000000000000000000000000000000000000000000000000000",
	shared_arith => "off")
-- pragma translate_on
;
END structure;


