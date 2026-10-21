
module TopModule (
    input wire x,
    input wire y,
    output reg z
);

    always @(posedge clk or negedge rst) begin
        if (~rst) begin
            z <= 0;
        end else begin
            z <= (x ^ y) & x;
        end
    end

endmodule
