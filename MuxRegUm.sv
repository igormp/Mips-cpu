module MuxRegUm(MuxReg1, AluOut, High, Low, MDR, RegDes, LT, PC, SL16, mux_out);

input [3:0] MuxReg1;
input [31:0] AluOut;
input [31:0] High;
input [31:0] Low;
input [31:0] MDR;
input [31:0] RegDes;
input [31:0] LT;
input [31:0] PC;
input [31:0] SL16;
output reg [31:0] mux_out;

always @ (MuxReg1)
begin

case(MuxReg1)
4'd0:mux_out <= AluOut;
4'd1:mux_out <= High;
4'd2:mux_out <= Low;
4'd3:mux_out <= MDR;
4'd4:mux_out <= 32'h227;
4'd5:mux_out <= RegDes;
4'd6:mux_out <= LT;
4'd7:mux_out <= PC;
4'd8:mux_out <= SL16;
endcase

end
endmodule
