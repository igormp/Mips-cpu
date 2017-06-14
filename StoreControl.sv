module StoreControl(StrCtrl, MDR, B, Out);

input StrCtrl;
input [31:0] MDR;
input [31:0] B;
output reg [31:0] Out;

always @ (StrCtrl)
begin
if(StrCtrl == 1'd0) 
begin

Out[31:8] = MDR[31:8];
Out[7:0] = B[7:0];

end 
else if(StrCtrl == 1'd1) 
begin

Out[31:16] = MDR[31:16];
Out[15:0] = B[15:0];

end
end
endmodule 