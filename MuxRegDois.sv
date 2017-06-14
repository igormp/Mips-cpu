module MuxRegDois(MuxReg2, Inst1, Inst2, mux_out);

input [2:0] MuxReg2;
input [4:0] Inst1;
input [4:0] Inst2;

output reg [4:0] mux_out;

always @ (MuxReg2)
begin

case(MuxReg2)
3'd0:mux_out <= Inst1;
3'd1:mux_out <= 5'd31;
3'd2:mux_out <= 5'd29;
3'd3:mux_out <= Inst2;
3'd4:mux_out <= 5'd30;
endcase

end
endmodule
