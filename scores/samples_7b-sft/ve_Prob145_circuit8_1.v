
module TopModule (
    input clock,
    input a,
    output p,
    output q
);

reg prev_a;

always @(posedge clock) begin
    prev_a <= a;
end

assign p = (~a) & prev_a;
assign q = (~a) & prev_a;

endmodule
