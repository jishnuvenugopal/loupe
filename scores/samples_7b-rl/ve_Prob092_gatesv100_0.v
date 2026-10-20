
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
 i = i + 1) begin : gen_out_both
            if (i == 99) begin
                assign out_both[i] = 1'b0;
            end else begin
                assign out_both[i] = in[i] & in[i + 1];
            end
        end
    endgenerate

    
    generate
        genvar j;
        for (j = 0;
 j < 100;
 j = j + 1) begin : gen_out_any
            if (j == 0) begin
                assign out_any[j] = 1'b0;
            end else begin
                assign out_any[j] = in[j] | in[j - 1];
            end
        end
    endgenerate

    
    generate
        genvar k;
        for (k = 0;
 k < 100;
 k = k + 1) begin : gen_out_different
            if (k == 0) begin
                assign out_different[k] = in[k] ^ in[99];
            end else begin
                assign out_different[k] = in[k] ^ in[k - 1];
            end
        end
    endgenerate

endmodule
