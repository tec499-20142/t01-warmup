module interfaceControl(
	input clk, 
	input reset, 
	input rx_data_ready, 
	input [7:0] rx_data, 
	output reg[7:0] data_a, 
	output reg[7:0] data_b,
	output reg[7:0] operation
	); 
	
	//========interno variaveis=======
	reg [7:0] data_a_temp; 
	reg [7:0] operation_temp; 
	reg [1:0] state;
	
	/**
		Um contador de 2 bits. Cada estado determina uma 
		operaÃ§ao da interface control. 
	*/
	always_ff @(posedge rx_data_ready, negedge reset)
		if(!reset)
			begin
				state <= 2'b00; 
			end
		else
			begin 
				if(state == 2'b11)
					begin 
						state <= 2'b00;
					end
				state <= state + 1;
			end 
	/***
		Um bloco para fazer atribuiÃ§ao do valor dos registradores temporarios
		para os registradores de saida. 
	*/
	 always_ff @(posedge clk, negedge reset) 
		if(!reset)
			begin 
				data_a <= 8'b0; 
				data_b <= 8'b0; 
				operation <= 8'b0; 
			end
		else 
		  begin 
		    case(state)
			   2'b01: operation_temp <= rx_data;
			   2'b10: data_a_temp <= rx_data; 
			   2'b11: 
			     begin 
			       data_b <= rx_data; 
			       operation <= operation_temp;
			       data_a <= data_a_temp; 
			     end  //Aqui falta a definiÃ§ao do estado 2'b11, 
		    endcase
		  end 

