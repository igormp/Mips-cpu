module MuxRegDes1(Controle, B, A, mux_out);

input Controle;
input [31:0] B;
input [31:0] A;
output reg [31:0] mux_out;

always @ (Controle)
begin

case(Controle)
1'd0:mux_out <= B;
1'd1:mux_out <= A;
endcase

end
endmodule 