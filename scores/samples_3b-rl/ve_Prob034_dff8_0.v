
module TopModule (
    input clk,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] dff;

    always @(posedge clk) begin
        dff <= d;
    end

    assign q = dff;

endmodule
