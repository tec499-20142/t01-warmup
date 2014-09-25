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
// PURPOSE: Realiza opera��es l�gicas e aritm�ticas a partir do valor da opera��o
// e dos operandos. No fim, armazena o resultado em registradores. Al�m disso, o
// modulo trata o overflow. Esse tratamento � feito baseado no resultado da opera��o
// que possui 16 bits de sa�da da ULA. Para permanecer fiel a arquitetura do projeto, 
// a sa�da do bloco possui 8 bits.
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
	input wire unsigned [7:0] data_a, 
	input wire unsigned [7:0] data_b, 
	input wire [7:0] operation,
	output logic unsigned[7:0] result_data,
	output logic overflow
);

	reg [15:0] result_reg;
	logic unsigned[15:0] outAlu;

	always_ff @(posedge clock, negedge reset)
		begin
			if(~reset) 
				begin
					result_reg <= 16'd0;
					result_data <= 8'd0;
				end
			else if(clock) 
			begin
			   result_reg <= outAlu;//Atualiza registrador
			   result_data <= result_reg[7:0];//atualiza sa�da
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
		
		overflow = (outAlu > 255);

	end


endmodule