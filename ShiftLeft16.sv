module ShiftLeft16(In, Out);

input [31:0] In;
output [31:0] Out;

assign Out[31:16] = In[15:0];
assign Out[15:0] = 16'd0;

endmodule 