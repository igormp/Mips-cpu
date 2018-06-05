module MuxRegDes2(Controle, Inst, B, mux_out);

input Controle;
input [4:0] Inst;
input [4:0] B;
output reg [4:0] mux_out;

always @ (Controle)
begin

case(Controle)
1'd0:mux_out <= Inst;
1'd1:mux_out <= B;
endcase

end
endmodule 