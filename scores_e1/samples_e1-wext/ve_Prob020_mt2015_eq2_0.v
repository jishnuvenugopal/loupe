
module TopModule (
    input  [1:0] A,
    input  [1:0] B,
    output reg z
);

always @(A, B) begin
    z = (A == B);
end

endmodule
