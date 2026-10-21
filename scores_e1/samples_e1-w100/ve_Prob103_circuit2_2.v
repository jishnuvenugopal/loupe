
module TopModule (
    input wire a,
    output wire q
);

always @(a) begin
    q <= ~a;
end

endmodule
