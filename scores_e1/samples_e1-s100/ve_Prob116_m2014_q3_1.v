
module TopModule (
    input wire [3:0] x,
    output reg f
);

always @(posedge clk or negedge rst) begin
    if (rst) begin
        f <= 0;
    end else begin
        if (x[1] == 0 && x[2] == 0 && x[3] == 1) begin
            f <= 1;
        end else begin
            f <= 0;
        end
    end
end

endmodule
