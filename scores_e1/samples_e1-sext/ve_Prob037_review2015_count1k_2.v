
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    counter counter (
        .clk(clk),
        .reset(reset),
        .enable(1'b1),
        .q(q)
    );

endmodule
