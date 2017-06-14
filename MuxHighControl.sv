module MuxHighControl(HighCtrl, Multi, Div, mux_out);

input HighCtrl;
input [31:0] Multi;
input [31:0] Div;
output reg [31:0] mux_out;

always @ (HighCtrl)
begin

case(HighCtrl)
1'd0:mux_out <= Multi;
1'd1:mux_out <= Div;
endcase

end
endmodule
