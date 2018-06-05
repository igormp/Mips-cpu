module MuxLowControl(LowCtrl, Multi, Div, mux_out);

input LowCtrl;
input [31:0] Multi;
input [31:0] Div;
output reg [31:0] mux_out;

always @ (LowCtrl)
begin

case(LowCtrl)
1'd0:mux_out <= Multi;
1'd1:mux_out <= Div;
endcase

end
endmodule