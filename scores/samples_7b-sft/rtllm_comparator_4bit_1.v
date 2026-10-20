
module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [4:0] borrow;
wire [3:0] diff;

assign borrow[0] = 1'b0;

genvar i;
generate
    for (i = 0;
 i < 4;
 i = i + 1) begin : subtractor_loop
        assign diff[i] = A[i] ^ B[i] ^ borrow[i];
        assign borrow[i + 1] = (~A[i] & B[i]) | (~A[i] & borrow[i]) | (B[i] & borrow[i]);
    end
endgenerate

assign A_less = borrow[4];
assign A_equal = (borrow[4] == 1'b0) && (& ~diff);
assign A_greater = (borrow[4] == 1'b0) && (|diff);

endmodule
