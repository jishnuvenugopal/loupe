
module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    assign out_both[99] = 1'b0;
    generate
        genvar i;
        for (i = 0;
 i < 99;
 i = i + 1) begin : both
            assign out_both[i] = in[i] & in[i+1];
        end
    endgenerate

    
    assign out_any[99] = 1'b0;
    generate
        for (i = 0;
 i < 99;
 i = i + 1) begin : any
            assign out_any[i] = in[i] | in[i+1];
        end
    endgenerate

    
    assign out_different[0] = in[0] ^ in[1];
    assign out_different[99] = in[99] ^ in[0];
    generate
        for (i = 1;
 i < 99;
 i = i + 1) begin : different
            assign out_different[i] = in[i] ^ in[i+1];
        end
    endgenerate

endmodule
