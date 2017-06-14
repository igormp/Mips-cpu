module UnsignedExtend32(In, Out);

input In;
output [31:0] Out;

assign Out = (In == 1'd1)? 32'd1:32'd0;

endmodule 