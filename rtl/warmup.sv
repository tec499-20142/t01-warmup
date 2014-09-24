module warmup(
input clk,
input rst,
input rx,
output reg result_data,
output reg overflow

);

wire _rx_ready;
wire _rx_data;
wire _data_a;
wire _data_b;
wire _operation;

uart BLOCO1 (
  .clk (rst),
  .rst (clk), 
  .rx (rx),
  .rx_ready (_rx_ready),
  .rx_data (_rx_data) 
  );
  
 interfaceControl BLOCO2 (
 
.clk(clk),
.reset(rst),
.rx_data_ready(_rx_ready),
.rx_data(_rx_data),
.data_a (_data_a),
.data_b(_data_b),
.operation(_operation) 
 );
 
 Processing_Unit BLOCO3 (
 
.clock(clk),
.reset(rst),
.data_a (_data_a),
.data_b(_data_a),
.operation(_operation),
.result_data(result_data),
.overflow(overflow)
 );
 endmodule
 
 