
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

always @(posedge clk) begin
    if (a == 1 && b == 1) begin
        state <= 1;
    end else if (a == 0 && b == 0) begin
        state <= 0;
    end else if (a == 1 && b == 0) begin
        state <= 0;
    end else if (a == 0 && b == 1) begin
        state <= 1;
    end
end

assign q = state;

endmodule
