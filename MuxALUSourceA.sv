module MuxALUSourceA(ALUSrcA, PC, MDR, A, mux_out);

input [1:0] ALUSrcA;
input [31:0] PC;
input [31:0] MDR;
input [31:0] A;
output reg [31:0] mux_out;

always @ (ALUSrcA)
begin

case(ALUSrcA)
2'd0:mux_out <= PC;
2'd1:mux_out <= MDR;
2'd2:mux_out <= A;
endcase

end
endmodule
