
module TopModule(
    input clk,
    input reset,
    input [7:0] d,
    output reg [7:0] q
);

    assign q = (reset) ? 8'h34 : d;

endmodule
