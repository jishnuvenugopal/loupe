
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [7:0] reset;
    reg [7:0] d_ff [7:0];

    always_ff @(posedge clk) begin
        if (areset) begin
            reset <= 1'b1;
            d_ff <= 8'b0;
        end else begin
            reset <= 1'b0;
            d_ff <= d;
        end
    end

    always @(posedge clk) begin
        if (reset) begin
            q <= 8'b0;
        end else begin
            q <= d_ff;
        end
    end

endmodule
