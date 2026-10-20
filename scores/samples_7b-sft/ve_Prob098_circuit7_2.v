
module TopModule (
    input clk,
    input a,
    output reg q
);

reg prev_a;

always @(posedge clk) begin
    prev_a <= a;
    if (prev_a && a) begin
        q <= ~q;
    end else if (!a) begin
        q <= 1'b1;
    end
end

endmodule
