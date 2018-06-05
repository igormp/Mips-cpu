module Multiplicador (A, B, resultHigh, resultLow, MultIn, MultOut, clk, Reset);

input [31:0] A, B;
input clk, Reset;
output reg [31:0] resultHigh, resultLow;
reg [64:0] Add, Sub, Produto;
reg [31:0] comp2;
output reg MultOut;
integer contador = 32;
input MultIn;


always @(posedge clk) begin

if (Reset  == 1) begin
resultHigh = 32'b0;
resultLow  = 32'b0;
MultOut    = 1'b0;
end

if (MultIn == 1'b1) begin
Add        = {A, 33'b0};
comp2      = (~A + 1'b1);
Sub        = {comp2, 33'b0};
Produto    = {32'b0, B, 1'b0};
contador   = 32;
MultOut    = 1'b0;
end

case (Produto[1:0])

2'b01: begin
 Produto = Produto + Add;
end

2'b10: begin
    Produto = Produto + Sub;
end

endcase

Produto = Produto >> 1;
if (Produto[63] == 1'b1) begin
Produto[64] = 1'b1;
end
if (contador > 0) begin
contador = (contador - 1);
end
if (contador == 0) begin
resultHigh   = Produto[64:33];
resultLow    = Produto[32:1];
MultOut      = 1'b1;
contador     = -1;
end
if(contador == -1)begin
    Add     = 65'd0;
    comp2   = 32'd0;
    Sub     = 65'd0;
    Produto = 65'd0; 
end
end

endmodule
