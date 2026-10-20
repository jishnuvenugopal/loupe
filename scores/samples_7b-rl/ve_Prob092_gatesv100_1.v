
module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    generate
        genvar i;
        for (i = 0;
 i < 100;
 i = i + 1) begin: gen_out_both
            if (i == 99)
                assign out_both[i] = 1'b0;
            else
                assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    
    assign out_any[0] = 1'b0;
    generate
        genvar j;
        for (j = 1;
 j < 100;
 j = j + 1) begin: gen_out_any
            assign out_any[j] = in[j] | in[j - 1];
        end
    endgenerate

    
    generate
        genvar jj;
        for (jj = 0;
 jj < 100;
 jj = jj + 1) begin: gen_out_diff
            if (jj == 99)
                assign out_different[jj] = in[jj] ^ in[0];
            else
                assign out_different[jj] = in[jj] ^ in[jj + 1];
        end
    endgenerate

endmodule
