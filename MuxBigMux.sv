module MuxBigMux(Controle, MemData, Alu, PC, AluOut, Inst, EPC, mux_out);

input [2:0] Controle;
input [31:0] MemData;
input [31:0] Alu;
input [31:0] PC;
input [31:0] AluOut;
input [31:0] Inst;
input [31:0] EPC;
output reg [31:0] mux_out;

always @ (Controle)
begin

case(Controle)
3'd0:mux_out <= MemData;
3'd1:mux_out <= Alu;
3'd2:mux_out <= PC;
3'd3:mux_out <= AluOut;
3'd4:mux_out <= Inst;
3'd5:mux_out <= EPC;
endcase

end
endmodule