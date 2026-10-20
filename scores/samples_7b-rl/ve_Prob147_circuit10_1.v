
module TopModule (
    input clk,
    input a,
    input b,
    output q,
    output reg state
);

    always @(posedge clk) begin
        state <= a | b;
    end

    assign q = a ^ state;

endmodule
