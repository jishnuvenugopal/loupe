
module TopModule (
    input  [7:0] in,
    output [7:0] out
);

    
    assign out = in[7:0] ^ in[6:1] ^ in[5:0] ^ in[4:1] ^ in[3:0] ^ in[2:1] ^ in[1:0] ^ in[0];

endmodule
