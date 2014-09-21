----------------------------------------------------------------------------------
-- Creation Date: 21:12:48 05/06/2010 
-- Module Name: RS232/UART Interface - Behavioral
-- Used TAB of 4 Spaces
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity uart is
generic (
	CLK_FREQ	: integer := 50;		-- Main frequency (MHz)
	SER_FREQ	: integer := 9600		-- Baud rate (bps)
);
port (
	-- Control
	clk			: in	std_logic;		-- Main clock
	rst			: in	std_logic;		-- Main reset
	-- External Interface
	rx			: in	std_logic;		-- RS232 received serial data
	-- uPC Interface
	rx_ready	: out	std_logic;						-- Received data ready to uPC read
	rx_data		: out	std_logic_vector(7 downto 0)	-- Received data 
);
end uart;

architecture Behavioral of uart is

	-- Constants
	constant UART_IDLE	:	std_logic := '1';
	constant UART_START	:	std_logic := '0';
	constant RST_LVL	:	std_logic := '1';

	-- Types
	type state is (idle,data);			-- Stop1 and Stop2 are inter frame gap signals

	-- RX Signals
	signal rx_fsm		:	state;							-- Control of reception
	signal rx_clk_en	:	std_logic;						-- Received clock enable
	signal rx_rcv_init	:	std_logic;						-- Start of reception
	signal rx_data_deb	:	std_logic;						-- Debounce RX data
	signal rx_data_tmp	:	std_logic_vector(7 downto 0);	-- Serial to parallel converter
	signal rx_data_cnt	:	std_logic_vector(2 downto 0);	-- Count received bits


begin

	rx_debounceer:process(clk) --controle que estabiliza
		variable deb_buf	:	std_logic_vector(3 downto 0);
	begin
		if clk'event and clk = '1' then
			-- Debounce logic
			if deb_buf = "0000" then
				rx_data_deb		<=	'0';
			elsif deb_buf = "1111" then
				rx_data_deb		<=	'1';
			end if;
			-- Data storage to debounce
			deb_buf				:=	deb_buf(2 downto 0) & rx;
		end if;
	end process;

	rx_start_detect:process(clk)
		variable rx_data_old	:	std_logic;
	begin
		if clk'event and clk = '1' then
			-- Falling edge detection
			if rx_data_old = '1' and rx_data_deb = '0' and rx_fsm = idle then
				rx_rcv_init		<=	'1';
			else
				rx_rcv_init		<=	'0';
			end if;
			-- Default assignments
			rx_data_old			:=	rx_data_deb;
			-- Reset condition
			if rst = RST_LVL then
				rx_data_old		:=	'0';
				rx_rcv_init		<=	'0';
			end if;
		end if;
	end process;


	rx_clk_gen:process(clk)
		variable counter	:	integer range 0 to conv_integer((CLK_FREQ*1_000_000)/SER_FREQ-1);
	begin
		if clk'event and clk = '1' then
			-- Normal Operation
			if counter = (CLK_FREQ*1_000_000)/SER_FREQ-1 or rx_rcv_init = '1' then
				rx_clk_en	<=	'1';
				counter		:=	0;
			else
				rx_clk_en	<=	'0';
				counter		:=	counter + 1;
			end if;
			-- Reset condition
			if rst = RST_LVL then
				rx_clk_en	<=	'0';
				counter		:=	0;
			end if;
		end if;
	end process;

	rx_proc:process(clk)
	begin
		if clk'event and clk = '1' then
			-- Default values
			rx_ready		<=	'0';
			-- Enable on UART rate
			if rx_clk_en = '1' then
				-- FSM description
				case rx_fsm is
					-- Wait to transfer data
					when idle =>
						if rx_data_deb = UART_START then
							rx_fsm		<=	data;
						end if;
						rx_data_cnt		<=	(others=>'0');
					-- Data receive
					when data =>
						if rx_data_cnt = 7 then
							-- Data path
							rx_data(7)		<=	rx;
							for i in 0 to 6 loop
								rx_data(i)	<=	rx_data_tmp(6-i);
							end loop;
								rx_ready	<=	'1';
								rx_fsm		<=	idle;
						end if;
						rx_data_tmp		<=	rx_data_tmp(6 downto 0) & rx;
						rx_data_cnt		<=	rx_data_cnt + 1;
				
					when others => null;
				end case;
				-- Reset condition
				if rst = RST_LVL then
					rx_fsm			<=	idle;
					rx_ready		<=	'0';
					rx_data			<=	(others=>'0');
					rx_data_tmp		<=	(others=>'0');
					rx_data_cnt		<=	(others=>'0');
				end if;
			end if;
		end if;
	end process;

end Behavioral;

