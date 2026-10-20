
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

assign out_both[99] = 0;
  
assign out_any[0] = 0;
    

assign out_both[98:0] = (in[98:0] & in[99:1]);

assign out_any[1:99] = (in[1:99] | in[0]);

assign out_different[98:0] = ^{in[99] ^ in[98:0], 1'b0};

endmodule
