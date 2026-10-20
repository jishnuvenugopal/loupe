
module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] dffs;

    always @(posedge clk) begin
        dffs <= d;
    end

    assign q = dffs;

endmodule
