
module TopModule (
    input wire [3:0] x,
    output reg f
);

    always @(posedge clk or negedge rst) begin
        if (!rst) begin
            f <= 0;
        end else begin
            f <= x[1] ^ x[2] ^ x[3];
        end
    end

endmodule
