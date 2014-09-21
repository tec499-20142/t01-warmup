// +UEFSHDR----------------------------------------------------------------------
// 2014 UEFS Universidade Estadual de Feira de Santana
// TEC499-Sistemas Digitais
// ------------------------------------------------------------------------------
// TEAM: Grupo1
// ------------------------------------------------------------------------------
// PROJECT: warm Up
// ------------------------------------------------------------------------------
// FILE NAME  : interfaceControl
// KEYWORDS 	: control
// -----------------------------------------------------------------------------
// PURPOSE: Gerenciar as informações recebidas pelo módulo UART atribuindo-as nos
// respectivos registradores de saída. 
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Reset Strategy      : asychronous, active in high level reset.
//   Clock Domains       : 50MHz
//   Instantiations      : <modules_id>
//   Synthesizable (y/n) : y
// -UEFSHDR----------------------------------------------------------------------
module interfaceControl(
	input clk, 
	input reset, 
	input rx_data_ready, 
	input [7:0] rx_data, 
	output [7:0] data_a, 
	output [7:0]data_b,
	output [7:0] operation); 
	
	//========interno variaveis=======
	reg [7:0] data_a_temp; 
	reg [7:0] data_b_temp; 
	reg [7:0] operation_temp; 
	reg [1:0] state;
	wire rx_data_temp; 
	
	/**
		Um contador de 2 bits. Cada estado determina uma 
		operaçao da interface control. 
	*/
	always_ff @(posedge clk)
		if(reset)
			begin
				state <= 2'b00; 
			end
		else if(rx_data_ready)
			begin 
				state <= state + 1; 
			end
	
	/**
		Similiar um mux. Cada estado do contador representa 
		o registrador adequado para inserir o valor. 
	*/
	always_latch
		case(state)
			2'b00: operation_temp = rx_data;
			2'b01: data_a_temp = rx_data; 
			2'b10: data_b_temp = rx_data;
			2'b11: ;//Aqui falta a definiçao do estado 2'b11, 
		endcase
			
			
	/***
		Um bloco para fazer atribuiçao do valor dos registradores temporarios
		para os registradores de saida. 
	*/
	 always_ff @(posedge clk)
		if(reset)
			begin 
				data_a <= 8'b00000000; 
				data_b <= 8'b00000000; 
				operation <= 8'b000000000; 
			end
		else if(state == 2'b11)
			begin
				operation <= operation_temp;
				data_a <= data_a_temp;
				data_b <= data_b_temp; 
			end 
			
endmodule 
