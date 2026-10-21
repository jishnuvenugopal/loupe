
module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    
    assign out = in[7:0] ^ in[6:1] ^ in[5:2] ^ in[4:3] ^ in[3:2] ^ in[2:1] ^ in[1:0];

endmodule
