
module TopModule (
    input clk,
    input reset,
    output reg [9:0] q
);

    always @(posedge clk) begin
        if (reset)
            q <= 10'd0;
        else
            q <= (q == 999) ? 10'd0 : q + 1;
    end

endmodule
