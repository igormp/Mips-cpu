module ShiftLeft2Conc(In, Out);

input [25:0] In;
output [27:0] Out;

assign Out[27:2] = In[25:0];
assign Out[1:0] = 2'd0;

endmodule 