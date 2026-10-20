
module TopModule (
    input  [7:0] in,
    output [7:0] out
);
generate
    for (genvar i = 0;
 i < 8;
 i = i + 1) begin : reverse_loop
        assign out[i] = in[7 - i];
    end
endgenerate
endmodule
