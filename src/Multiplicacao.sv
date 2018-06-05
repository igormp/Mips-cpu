module multiplicacao (A, B, resultHigh, resultLow, MultOut, clk, Reset);

input [31:0] A, B;
input clk, Reset;
output reg [31:0] resultHigh, resultLow;
reg [64:0] Add, Sub, Produto;
output reg MultOut;
reg [4:0] contador;
reg MultIn;

//initial begin
//	MultIn <= 1'b1;
//end

always @(negedge clk) begin
MultIn <= 1'b1;

if (Reset) begin

resultHigh <= 32'b0;
resultLow <= 32'b0;

end

else if (MultIn == 1) begin

Add         <= {A, 33'b0};
Sub         <= {-A, 33'b0};
Produto     <= {1'b0, B, 1'b0};
contador    <= 5'b0;
MultIn      <= 1'b0;
end

case (Produto[64:63])

2'b01: begin
Produto <= Produto + Add;
end

2'b10: begin
Produto <= Produto + Sub;
end
endcase

Produto[63:0] <= Produto[63:0] >> 1;
contador      <= contador + 1;

if (contador == 32) begin
resultHigh  <= Produto[64:33];
resultLow   <= Produto[32:1];
MultOut     <= 1'b1;
contador    <= 5'b0;
end

end

endmodule
