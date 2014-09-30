-- +UEFSHDR----------------------------------------------------------------------
-- 2014 UEFS Universidade Estadual de Feira de Santana
-- TEC499-Sistemas Digitais
-- ------------------------------------------------------------------------------
-- TEAM: 01
-- ------------------------------------------------------------------------------
-- PROJECT: Warm up
-- ------------------------------------------------------------------------------
-- FILE NAME  : interface_tb
-- KEYWORDS 	test, interface, control
-- -----------------------------------------------------------------------------
-- PURPOSE: Testa o módulo internet control 
-- -UEFSHDR----------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity interface_tb is
end interface_tb;

architecture Behavioral of interface_tb is
	
	----------------------------------------------
	-- Constants
	----------------------------------------------
	constant MAIN_CLK_PER : time                 := 20 ns; -- 50 MHz
	constant MAIN_CLK     : integer              := 50;
	constant BAUD_RATE    : integer              := 9600; -- Bits per Second
	constant RST_LVL      : std_logic            := '1'; -- Active Level of Reset

	----------------------------------------------
	-- Signal Declaration
	----------------------------------------------
	-- Clock and reset Signals
	signal clk_50m : std_logic := '0';
	signal rst     : std_logic;

	signal rx_ready_in : std_logic;
	signal rx_data_in  : std_logic_vector(7 downto 0);
	
	-- componente descrito como manda o documento de arquitetura, 
	-- segundo fontes, caso o mapeamento das portas seja esse, funciona
	-- independentemente da linguagem.

	component interfaceControl is 
	port (
		clk: in std_logic;
		reset: in std_logic; 
		rx_data_ready: in std_logic; 
		rx_data: in std_logic_vector(7 downto 0);
		data_a: out std_logic_vector(7 downto 0);
		data_b: out std_logic_vector(7 downto 0);
		operation: out std_logic_vector(7 downto 0)
	);
	end component;	
begin

	----------------------------------------------
	-- Components Instantiation
	----------------------------------------------
	uut: component interfaceControl port map(
			-- Controle
			clk         => clk_50m, -- seta clock para o gerado por este rtl
			reset         => rst,    -- seta o reset para o gerado por este rtl

			-- interface de entrada
			rx_data_ready => rx_ready_in, -- seta o pino que anuncia a transmissão
			rx_data       => rx_data_in, -- seta o pino que tem os dados da transmissão

			-- Saídas
			data_a       => open,
			data_b       => open,
			operation    => open
		);

	----------------------------------------------
	-- Main Signals Generation
	----------------------------------------------
	-- gera clocl que é enviado para o modulo de interface_control
	main_clock_generation : process
	begin
		wait for MAIN_CLK_PER / 2;
		clk_50m <= not clk_50m;
	end process;
  
	
	envia_dados : process
	variable temp         : integer := 1;
	begin
		--verifica qual o valor de temp, pois temp define qual dado será enviado
		if temp = 1 then
			rx_data_in <= "00000001";
			temp:= temp +1;
		elsif temp = 2 then
			rx_data_in <= "01000010";
			temp:= temp+1;
		else
			 rx_data_in <= "11111111";
		end if;
		-- atraso 
		wait for 100ns;
		-- rx_ready_in fica com valor '1' durante tempo de um pulso de clock
		rx_ready_in <= '1';
		wait for MAIN_CLK_PER / 2;
		rx_ready_in <= '0';

		-- reinicia a variavel temp e envia um reset caso 3 dados já forem enviados
		if temp = 3 then
			temp := 1;
			wait for 200ns;
			rst <= '0';
			wait for MAIN_CLK_PER /2;
	 		rst <= '1';
		end if;
		
	end process envia_dados; 
	
end Behavioral;