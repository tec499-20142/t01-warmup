----------------------------------------------------------------------------------
-- Creation Date: 13:07:48 27/03/2011 
-- Module Name: RS232/UART Interface - Testbench
-- Used TAB of 4 Spaces
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart_tb is
end uart_tb;

architecture Behavioral of uart_tb is

	----------------------------------------------
	-- Constants
	----------------------------------------------
	constant MAIN_CLK_PER	:	time := 20 ns;		-- 50 MHz
	constant MAIN_CLK     : integer := 50;
	constant BAUD_RATE		:	integer := 9600;	-- Bits per Second
	constant RST_LVL		:	std_logic := '1';	-- Active Level of Reset
	constant TEST_RX : std_logic := '0';

	----------------------------------------------
	-- Signal Declaration
	----------------------------------------------
	-- Clock and reset Signals
	signal clk_50m					:	std_logic := '0';
	signal rst						:	std_logic;
	signal test						:	std_logic;
	-- Transceiver Interface
	signal data_from_transceiver	:	std_logic := '1';
	-- uPC Interface
	signal rx_ready					:	std_logic;
	signal rx_data					:	std_logic_vector(7 downto 0);

	-- Testbench Signals
	signal uart_clk					:	std_logic := '0';
begin

	----------------------------------------------
	-- Components Instantiation
	----------------------------------------------
	uut:entity work.uart
	generic map(
		CLK_FREQ	=> MAIN_CLK,				-- Main frequency (MHz)
		SER_FREQ	=> BAUD_RATE				-- Baud rate (bps)
	)
	port map(
		-- Control
		clk			=> clk_50m,					-- Main clock
		rst			=> rst,						-- Main reset
		-- External Interface
		rx			=> data_from_transceiver,	-- RS232 received serial data
		-- uPC Interface
		rx_ready	=> rx_ready,				-- Received data ready to uPC read
		rx_data		=> rx_data					-- Received data 
	);

	----------------------------------------------
	-- Main Signals Generation
	----------------------------------------------
	-- Main Clock generation
	main_clock_generation:process
	begin
		wait for MAIN_CLK_PER/2;
		clk_50m		<= not clk_50m;
	end process;

	-- UART Clock generation
	uart_clock_generation:process
	begin
		wait for (MAIN_CLK_PER*5208)/2;
		uart_clk	<= not uart_clk;
	end process;
	
	-- RX Clock generation
	rx_clock_generation:process
	begin
		wait for (MAIN_CLK_PER*5100*2);
		data_from_transceiver	<= not data_from_transceiver; -- start bit
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; --primeiro bit (1)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; --segundo bit (0)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= data_from_transceiver; --terceiro bit (0)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; -- quarto (1)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= data_from_transceiver; -- quinto (1)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; -- sexto (0)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; -- setimo (1)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; -- oitavo (0)
		wait for (MAIN_CLK_PER*5208);
		data_from_transceiver	<= not data_from_transceiver; --Stop bit
		
	end process;
	

	-- Reset generation

	rst	<=	RST_LVL, not RST_LVL after MAIN_CLK_PER*5;

	
	
end Behavioral;

