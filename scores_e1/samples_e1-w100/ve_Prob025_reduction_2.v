
module TopModule (
    input  [7:0] in,
    output reg parity
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            parity <= 0;
        end else begin
            parity <= in ^ parity;
        end
    end

endmodule
