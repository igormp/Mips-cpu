module MuxMDR(Controle, Normal, Byte, HalfWord, mux_out);

input [1:0] Controle;
input [31:0] Normal;
input [31:0] Byte;
input [31:0] HalfWord;
output reg [31:0] mux_out;

always @ (Controle)
begin

case(Controle)
2'b00:mux_out <= Normal;
2'b01:mux_out <= Byte;
2'b10:mux_out <= HalfWord;
endcase

end
endmodule 