module MuxStore(StoreCtrl, StoreControl, B, mux_out);

input StoreCtrl;
input [31:0] StoreControl;
input [31:0] B;
output reg [31:0] mux_out;

always @ (StoreCtrl)
begin

case(StoreCtrl)
1'd0:mux_out <= StoreControl;
1'd1:mux_out <= B;
endcase

end
endmodule 