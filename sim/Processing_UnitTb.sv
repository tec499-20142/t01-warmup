// +UEFSHDR----------------------------------------------------------------------
// 2014 UEFS Universidade Estadual de Feira de Santana
// TEC499-Sistemas Digitais
// ------------------------------------------------------------------------------
// TEAM: Grupo1
// ------------------------------------------------------------------------------
// PROJECT: Warm Up
// ------------------------------------------------------------------------------
// FILE NAME  : Processing_UnitTb
// KEYWORDS 	: ULA, ALU, teste
// -----------------------------------------------------------------------------
// PURPOSE: Testa todas as opera��es do modulo Processing_Unit.
// -----------------------------------------------------------------------------
module Processing_UnitTb;
//Defini��o de variaveis para os testes
reg [7:0] a, b; //entradas para a opera��o ex: a+b
reg [7:0] opcode; //codigo da op
reg clock;
reg reset;
wire [7:0] y;//saida
wire overflow;

initial begin 
  //aqui dentro, inicio a logica do teste
  $monitor ("opcode=%b,a=%b,b=%b,y=%b", opcode,a,b,y);
    //inicio tudo em 0
    clock = 0;
    reset = 1;
    opcode = 0;
    a = 0;
    b = 0;
    #1 reset = 0;
    #1 reset = 1;//Reset
      #5  opcode = 8'b00101011;//opera��o de soma
      a = 8'd15; //+15
       b = 8'd10; //+10
     #10  //=25
     #4 opcode = 8'b00101011;
      a = 8'd120;//120
      b = 8'd10;//+10
     #10 //Overflow de soma
     #1 reset = 0;
     #1 reset = 1;
     #4 opcode = 8'b00101101;//subtra��o
     a = 8'd125;
     b = 8'd110;
     #10 //-10
    #1 opcode = 8'b00101101;//subtra��o
    a = -40;
    b = 117;
    #10 //Overflow de subtra��o
    #1 reset = 0;
    #1 reset = 1;
    #4 opcode = 8'b00101010;//multiplica��o
    a = 3;
    b = 2;
    #10 //=6
    #4 opcode = 8'b00101010;//multiplica��o
    a = 10;
    b = 20;
    #10 //overflow multiplica��o
    #4 opcode = 8'b00101111;//Divis�o
    a = 15;
    b = 5;
    #10 //=6
    #4 opcode = 8'b00100110; // AND
    a = 8'b00000001;
    b = 8'b11111110;
    #10 //= b00000000
    #4 opcode = 8'b01111100; //OR
    a = 8'b00000001;
    b = 8'b11111110;
    #10 //= b11111111
     $finish; //  aguardo 10 unidades de tempo e finalizo o teste
end


//Clock do bloco de registradores
  always 
  begin
    #1  clock =  ! clock;
 end

//Aqui eu instancio o modulo que eu quero testar. Nesse caso, o modulo Processing_Unit � o que eu quero testar.
Processing_Unit U0 (
  .reset (reset),//associo o wire reset do teste com o reset da ula
  .clock (clock), //fa�o o mesmo
  .data_a (a), //fa�o o mesmo
  .data_b (b),
  .operation (opcode),
  .overflow (overflow),
  .result_data (y) //fa�o o mesmo
  //Basicamente, associei o meu teste ao modulo que quero testar.
  );
endmodule
