
module TopModule (
    input clock,
    input a,
    output reg p,
    output reg q
);

reg a_prev;

always @(posedge clock) begin
    a_prev <= a;
    p <= (a_prev && !a);
    q <= (a_prev && !a);
end

endmodule
