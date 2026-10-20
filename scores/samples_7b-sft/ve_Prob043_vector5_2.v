
module TopModule (
    input a, b, c, d, e,
    output [24:0] out
);

wire [4:0] elements = {a, b, c, d, e};

genvar i, j;
generate
    for (i = 0;
 i < 5;
 i = i + 1) begin : gen_i
        for (j = 0;
 j < 5;
 j = j + 1) begin : gen_j
            assign out[24 - i*5 - j] = ~(elements[i] ^ elements[j]);
        end
    end
endgenerate

endmodule
