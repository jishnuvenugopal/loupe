
module TopModule(
    input clk,
    input a,
    output reg [2:0] q = 4
);

    always @(posedge clk, negedge clk) begin
        if (a)
            q <= 4;
        else
            q <= q + 1;
    end

endmodule
