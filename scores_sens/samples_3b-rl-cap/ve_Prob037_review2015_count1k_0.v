
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    reg [9:0] counter;

    always @(posedge clk) begin
        if (reset) begin
            q <= 10'd0;
            counter <= 10'd0;
        end else begin
            counter <= counter + 1;
            if (counter == 10'd1000) begin
                counter <= 10'd0;
                q <= q + 1;
            end
        end
    end

endmodule
