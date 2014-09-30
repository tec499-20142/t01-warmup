module warmup(
input clk,
input rst,
input rx,
output reg [7:0] result_data,
output overflow

);

wire _rx_ready;
wire [7:0]_rx_data;
wire [7:0]_data_a;
wire [7:0]_data_b;
wire [7:0]_operation;

uart BLOCO1 (
  .clk (clk),
  .rst (rst),
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
.data_b(_data_b),
.operation(_operation),
.result_data(result_data),
.overflow(overflow)
 );
 endmodule
