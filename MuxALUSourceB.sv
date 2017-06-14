module MuxALUSourceB(ALUSrcB, B, Inst, InstShift, RegDes, mux_out);

input [2:0] ALUSrcB;
input [31:0] B;
input [31:0] Inst;
input [31:0] InstShift;
input [31:0] RegDes;
output reg [31:0] mux_out;

always @ (ALUSrcB)
begin

case(ALUSrcB)
3'd0:mux_out <= B;
3'd1:mux_out <= 32'd4;
3'd2:mux_out <= Inst;
3'd3:mux_out <= InstShift;
3'd4:mux_out <= RegDes;
endcase

end
endmodule
