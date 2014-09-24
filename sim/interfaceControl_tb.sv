module interfaceControl_tb; 

  reg clk, reset, rx_data_ready; 
  reg [7:0] rx_data; 
  wire data_a, data_b, operation; 
  
  interfaceControl ic(.clk(clk), 
  .reset(reset), 
  .rx_data_ready(rx_data_ready), 
  .rx_data(rx_data),
  .data_a(data_a),
  .data_b(data_b), 
  .operation(operation)); 
  
endmodule