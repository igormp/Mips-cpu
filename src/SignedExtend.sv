module SignedExtend(In, Out);

input [15:0] In;
output [31:0] Out;

assign Out[15:0] = In[15:0];

assign Out[31:16] = (In[15] == 1'd1)? 1111111111111111:0000000000000000;


endmodule 