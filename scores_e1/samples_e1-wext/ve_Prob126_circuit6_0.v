
module TopModule (
    input  [2:0] a,
    output [15:0] q
);

always_comb begin
    q = a;
end

endmodule
