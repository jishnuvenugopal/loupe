
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
 i = i + 1) begin : both_loop
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    
    assign out_any[0] = 1'b0;
    generate
        genvar j;
        for (j = 1;
 j < 100;
 j = j + 1) begin : any_loop
            assign out_any[j] = in[j] | in[j - 1];
        end
    endgenerate

    
    assign out_different = in ^ {in[0], in[99:1]};

endmodule
