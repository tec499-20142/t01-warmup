// +UEFSHDR----------------------------------------------------------------------
// 2014 UEFS Universidade Estadual de Feira de Santana
// TEC499-Sistemas Digitais
// ------------------------------------------------------------------------------
// TEAM: Grupo1
// ------------------------------------------------------------------------------
// PROJECT: warm Up
// ------------------------------------------------------------------------------
// FILE NAME  : Processing_Unit
// KEYWORDS 	: ULA, ALU.
// -----------------------------------------------------------------------------
// PURPOSE: Realiza operações lógicas e aritméticas a partir do valor da operação
// e dos operandos. No fim, armazena o resultado em registradores. Além disso, o
// modulo trata o overflow. Esse tratamento é feito baseado no resultado da operação
// que possui 16 bits de saída. Essa saída de 16bits é analisada por um circuito
// combinacional para verificar se houve um estouro da quantidade de bits desejada (8bits).
// Para permanecer fiel a arquitetura do projeto, a saída possui 8 bits.
// -----------------------------------------------------------------------------
// REUSE ISSUES
//   Reset Strategy      : asychronous, active in low level reset.
//   Clock Domains       : 50MHz
//   Instantiations      : <modules_id>
//   Synthesizable (y/n) : y
// -UEFSHDR----------------------------------------------------------------------
module Processing_Unit(
	input wire reset,
	input wire clock,
	input wire signed [7:0] data_a, 
	input wire signed [7:0] data_b, 
	input wire [7:0] operation,
	output logic signed[7:0] result_data,
	output logic overflow
);

	reg signed[15:0] result_reg;
	logic signed[15:0] outAlu;

	always_ff @(posedge clock, negedge reset)
		begin
			if(~reset) 
				begin
					result_reg <= 16'd0;
				end
			else if(clock) 
			begin
				result_reg <= outAlu;//Atualiza registrador
				for(int i = 0; i < 8; i++) 
				begin
				  result_data[i] <= result_reg[i];//atualiza saída
				end
			end
		end

		
	always_comb 
	begin 
		case(operation[7:0])
			8'b00101011: 
					outAlu = data_a + data_b;
			8'b00101101: 
					outAlu = data_a - data_b;
			8'b00101010:
					outAlu = data_a * data_b;
			8'b00101111:
					outAlu = data_a / data_b;
			8'b00100110:
					outAlu = data_a & data_b;
			8'b01111100: 
					outAlu = data_a | data_b;
			default
					outAlu = 16'd0;
		endcase
    
	  	
	end

	
	always_comb
	begin
		
		overflow = ((outAlu > 128) 
		|| (outAlu < -127));

	end


endmodule
