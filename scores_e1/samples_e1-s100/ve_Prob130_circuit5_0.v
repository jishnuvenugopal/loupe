
module TopModule (
    input [3:0] a,
    input [3:0] b,
    input [3:0] c,
    input [3:0] d,
    input [3:0] e,
    output reg q
);

always @(a or b or c or d or e) begin
    q <= a & b & c & d & e;
end

endmodule
