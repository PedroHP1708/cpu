-- Copyright (C) 2021  Intel Corporation. All rights reserved.
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
-- VERSION "Version 21.1.0 Build 842 10/21/2021 SJ Lite Edition"

-- DATE "12/02/2024 20:42:07"

-- 
-- Device: Altera 5CEBA4F23C7 Package FBGA484
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

ENTITY 	cpu IS
    PORT (
	clk : IN std_logic;
	reset : IN std_logic;
	enableRead : IN std_logic;
	inputs : IN std_logic_vector(7 DOWNTO 0);
	outputs : BUFFER std_logic_vector(7 DOWNTO 0)
	);
END cpu;

-- Design Ports Information
-- enableRead	=>  Location: PIN_B6,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[0]	=>  Location: PIN_AB11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[1]	=>  Location: PIN_W2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[2]	=>  Location: PIN_U20,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[3]	=>  Location: PIN_Y3,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[4]	=>  Location: PIN_AB17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[5]	=>  Location: PIN_V18,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[6]	=>  Location: PIN_L22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- outputs[7]	=>  Location: PIN_AA7,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- clk	=>  Location: PIN_H13,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- reset	=>  Location: PIN_J17,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[0]	=>  Location: PIN_R11,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[1]	=>  Location: PIN_AB5,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[2]	=>  Location: PIN_V9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[3]	=>  Location: PIN_C2,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[4]	=>  Location: PIN_W22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[5]	=>  Location: PIN_K22,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[6]	=>  Location: PIN_K9,	 I/O Standard: 2.5 V,	 Current Strength: Default
-- inputs[7]	=>  Location: PIN_G13,	 I/O Standard: 2.5 V,	 Current Strength: Default


ARCHITECTURE structure OF cpu IS
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
SIGNAL ww_enableRead : std_logic;
SIGNAL ww_inputs : std_logic_vector(7 DOWNTO 0);
SIGNAL ww_outputs : std_logic_vector(7 DOWNTO 0);
SIGNAL \enableRead~input_o\ : std_logic;
SIGNAL \clk~input_o\ : std_logic;
SIGNAL \reset~input_o\ : std_logic;
SIGNAL \inputs[0]~input_o\ : std_logic;
SIGNAL \inputs[1]~input_o\ : std_logic;
SIGNAL \inputs[2]~input_o\ : std_logic;
SIGNAL \inputs[3]~input_o\ : std_logic;
SIGNAL \inputs[4]~input_o\ : std_logic;
SIGNAL \inputs[5]~input_o\ : std_logic;
SIGNAL \inputs[6]~input_o\ : std_logic;
SIGNAL \inputs[7]~input_o\ : std_logic;
SIGNAL \~QUARTUS_CREATED_GND~I_combout\ : std_logic;

BEGIN

ww_clk <= clk;
ww_reset <= reset;
ww_enableRead <= enableRead;
ww_inputs <= inputs;
outputs <= ww_outputs;
ww_devoe <= devoe;
ww_devclrn <= devclrn;
ww_devpor <= devpor;

-- Location: IOOBUF_X25_Y0_N36
\outputs[0]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(0));

-- Location: IOOBUF_X0_Y18_N62
\outputs[1]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(1));

-- Location: IOOBUF_X52_Y0_N36
\outputs[2]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(2));

-- Location: IOOBUF_X0_Y18_N45
\outputs[3]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(3));

-- Location: IOOBUF_X38_Y0_N53
\outputs[4]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(4));

-- Location: IOOBUF_X51_Y0_N2
\outputs[5]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(5));

-- Location: IOOBUF_X54_Y19_N56
\outputs[6]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(6));

-- Location: IOOBUF_X18_Y0_N53
\outputs[7]~output\ : cyclonev_io_obuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	open_drain_output => "false",
	shift_series_termination_control => "false")
-- pragma translate_on
PORT MAP (
	i => GND,
	devoe => ww_devoe,
	o => ww_outputs(7));

-- Location: IOIBUF_X14_Y45_N35
\enableRead~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_enableRead,
	o => \enableRead~input_o\);

-- Location: IOIBUF_X38_Y45_N1
\clk~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_clk,
	o => \clk~input_o\);

-- Location: IOIBUF_X44_Y45_N35
\reset~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_reset,
	o => \reset~input_o\);

-- Location: IOIBUF_X25_Y0_N1
\inputs[0]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(0),
	o => \inputs[0]~input_o\);

-- Location: IOIBUF_X16_Y0_N75
\inputs[1]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(1),
	o => \inputs[1]~input_o\);

-- Location: IOIBUF_X16_Y0_N58
\inputs[2]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(2),
	o => \inputs[2]~input_o\);

-- Location: IOIBUF_X0_Y21_N38
\inputs[3]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(3),
	o => \inputs[3]~input_o\);

-- Location: IOIBUF_X48_Y0_N75
\inputs[4]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(4),
	o => \inputs[4]~input_o\);

-- Location: IOIBUF_X54_Y21_N55
\inputs[5]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(5),
	o => \inputs[5]~input_o\);

-- Location: IOIBUF_X34_Y45_N52
\inputs[6]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(6),
	o => \inputs[6]~input_o\);

-- Location: IOIBUF_X38_Y45_N18
\inputs[7]~input\ : cyclonev_io_ibuf
-- pragma translate_off
GENERIC MAP (
	bus_hold => "false",
	simulate_z_as => "z")
-- pragma translate_on
PORT MAP (
	i => ww_inputs(7),
	o => \inputs[7]~input_o\);

-- Location: LABCELL_X35_Y30_N0
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


