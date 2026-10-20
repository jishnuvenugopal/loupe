
module TopModule (
    input clk,
    input reset,
    output reg [4:0] q
);

    reg feedback;

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b11111;
        end else begin
            feedback = q[4] ^ q[2];
            q <= {q[3:0], feedback};
        end
    end

endmodule
