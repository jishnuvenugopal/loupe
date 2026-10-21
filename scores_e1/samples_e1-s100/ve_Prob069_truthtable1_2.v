
module TopModule (
    input wire x3,
    input wire x2,
    input wire x1,
    output reg f
);

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        f <= 0;
    end else begin
        f <= (x3 | x2 | x1);
    end
end

endmodule
