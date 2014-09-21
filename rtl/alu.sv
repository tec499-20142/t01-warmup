module alu(
		input  logic clock,
		input  logic reset,
		input  logic[7:0] signed data_a,
		input  logic[7:0] signed data_b,
		input  logic[7:0] operation,
		output logic[7:0] signed result_data,
		output logic overflow,
		reg enable_result_reg,
		reg [7:0] result_reg,
	);

	/**
	 * Task que processará as operações lógicas e aritméticas.
	 * Primeiro checa-se qual operação será realizada.
	 *
	 * Operadores:
	 *		Soma			(+) : 00101011
	 *		Subtração		(-) : 00101101
	 *		Multiplicação	(*) : 00101010
	 *		Divisão			(/) : 00101111
	 *		AND 			(&) : 00100110
	 *		OR 				(|) : 01111100
	 */


	task process_operation;
		input  operation, op_a, op_b;
		output result;
		begin

			unique case (operation)
				8'b00101011: result = op_a + op_b;
				8'b00101101: result = op_a - op_b;
				8'b00101010: result = op_a * op_b;
				8'b00101111: result = op_a / op_b;
				8'b00100110: result = op_a && op_b;
				8'b01111100: result = op_a || op_b;
				default: ;
			endcase

		end
	endtask

	task setup_flag;
		input result, operation;
		output overflow;
		begin
			unique case (operation)
				8'b00101011: overflow = result[7]; // recebe diretamente o bit de sinal. Se for 1, indica que ocorreu overflow na soma.
				8'b00101101: overflow = result[7] && ~(
										result[6] ||
										result[5] ||
										result[4] ||	/* recebe bit_sinal && !(or result_data 6 downto 0) */
										result[3] ||
										result[2] ||
										result[1] ||
										result[0]
									);
				default: ;
			endcase

		end
	endtask


	always_comb begin

		/*	Colocar as instruções
		*	Será recebido o valor ASCII
		*	TIP: Possivelmente adicionar três always para os blocos!
		*	TIP2: Como será recebido os opcodes. Olhar a tabela ASCII
		*/

		process_operation(operation, data_a, data_b, result_data);
		setup_flag(result_data, operation, overflow);

	end


endmodule
