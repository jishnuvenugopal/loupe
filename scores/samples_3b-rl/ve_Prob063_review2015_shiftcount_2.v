
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (count_ena) begin
        q <= q - 1'b1;
    end else if (shift_ena) begin
        q <= {q[2:0], 1'b0};
    end
    
end



endmodule
