
module TopModule (
    input  [99:0] in,
    output [99:0] out
);

    
    assign out = in[99:0] ^ (in[98:0] << 1) ^ (in[97:0] << 2) ^ ...
                  ^ (in[0:0] << 98);

endmodule
