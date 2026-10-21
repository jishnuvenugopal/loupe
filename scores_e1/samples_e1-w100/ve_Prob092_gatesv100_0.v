
module TopModule (
    input  [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    assign out_both = {99'b0, in[98:0]};
    assign out_any = {99'b0, in[1:0]};
    assign out_different = {99'b0, in[0:99]};

endmodule
