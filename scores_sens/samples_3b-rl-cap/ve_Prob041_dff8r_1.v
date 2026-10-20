
module TopModule (
    input clk,
    input reset,
    input [7:0] d,
    output [7:0] q
);

    reg [7:0] d_ff [7:0];

    always @(posedge clk) begin
        if (reset) begin
            d_ff[7] <= 8'b0;
            d_ff[6] <= 8'b0;
            d_ff[5] <= 8'b0;
            d_ff[4] <= 8'b0;
            d_ff[3] <= 8'b0;
            d_ff[2] <= 8'b0;
            d_ff[1] <= 8'b0;
            d_ff[0] <= 8'b0;
        end else begin
            d_ff[7] <= d[7];
            d_ff[6] <= d[6];
            d_ff[5] <= d[5];
            d_ff[4] <= d[4];
            d_ff[3] <= d[3];
            d_ff[2] <= d[2];
            d_ff[1] <= d[1];
            d_ff[0] <= d[0];
        end
    end

    assign q = {d_ff[7], d_ff[6], d_ff[5], d_ff[4], d_ff[3], d_ff[2], d_ff[1], d_ff[0]};

endmodule
