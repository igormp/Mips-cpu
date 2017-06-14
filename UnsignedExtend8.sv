module UnsignedExtend8(In, Out);

input [7:0] In;
output [31:0] Out;

assign Out[7:0] = In[7:0];
assign Out[31:8] = 24'd0;

endmodule 