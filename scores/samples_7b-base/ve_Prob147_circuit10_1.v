
module TopModule(
    input clk,
    input a,
    input b,
    output reg q,
    output reg state
);

reg prev_a, prev_b;

always @(posedge clk) begin
    prev_a <= a;
    prev_b <= b;
    
    if (a == 1 && b == 0) begin
        state <= ~state;
    end else begin
        state <= state;
    end
end

always @(posedge clk) begin
    if (a == 1 && b == 0) begin
        q <= ~q;
    end else begin
        q <= q;
    end
end

assign q = a | b;

endmodule
