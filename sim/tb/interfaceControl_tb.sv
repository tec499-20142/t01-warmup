module interfaceControl_tb; 

  reg clk, reset, rx_data_ready; 
  reg [7:0] rx_data; 
  wire [7:0] data_a, data_b, operation;
  
  interfaceControl ic(.clk(clk), 
  .reset(reset), 
  .rx_data_ready(rx_data_ready), 
  .rx_data(rx_data),
  .data_a(data_a),
  .data_b(data_b), e
  .operation(operation), 
   ); 
  
  initial 
    begin 
      $display ("time\t clk reset rx_data_ready rx_data operation data_a data_b");	
      $monitor ("%g\t %b   %b     %b      %b   %b    %b    %b", 	$time, clk, reset, rx_data_ready,
      rx_data, operation, data_a, data_b);	
      clk = 0; 
      #1 reset = 1;
      #1 reset = 0;
      #1 reset = 1;
      
      rx_data_ready = 1;
      
      #1 rx_data = 8'b00001000;
      rx_data_ready = 0;
      
      #10 //idle
      
      rx_data_ready = 1;
      
      #1 rx_data = 8'b00001001;
      rx_data_ready = 0;
      
      #10 //reading
      
      rx_data_ready = 1;
      
      #1 rx_data = 8'b00001010;
      rx_data_ready = 0;
      
      
      #5 $finish; 
    end 
  
  always 
    #1 clk = !clk; 
endmodule
