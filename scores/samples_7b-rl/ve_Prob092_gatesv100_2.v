
module TopModule (
    input [99:0] in,
    output [99:0] out_both,
    output [99:0] out_any,
    output [99:0] out_different
);

    
    assign out_both[99] = 1'b0;
    genvar i;
    generate
        for (i = 0;
 i < 99;
 i = i + 1) begin : gen_out_both
            assign out_both[i] = in[i] & in[i + 1];
        end
    endgenerate

    
    assign out_any[0] = 1'b0;
    genvar j;
    generate
        for (j = 1;
 j < 100;
 j = j + 1) begin : gen_out_any
            assign out_any[j] = in[j] | in[j - 1];
        end
    endgenerate

    
    genvar k;
    generate
        for (k = 0;
 k < 100;
 k = k + 1) begin : gen_out_diff
            if (k == 99) begin
                assign out_different[k] = in[k] ^ in[0];
            end else begin
                assign out_different[k] = in[k] ^ in[k + 1];
            end
        end
    endgenerate

endmodule
