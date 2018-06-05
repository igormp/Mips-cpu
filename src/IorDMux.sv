module IorDMux(IorD, PC, A_imediato, AluOut, mux_out);

input [2:0] IorD;
input [31:0] PC;
input [31:0] A_imediato;
input [31:0] AluOut;
output reg [31:0] mux_out;

always @ (IorD)
begin

case(IorD)
3'd0:mux_out <= PC;
3'd1:mux_out <= A_imediato;
3'd2:mux_out <= AluOut;
3'd3:mux_out <= 32'h253;
3'd4:mux_out <= 32'h254;
3'd5:mux_out <= 32'h255;
endcase

end
endmodule 