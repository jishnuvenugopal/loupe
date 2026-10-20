
module TopModule (
    input clk,
    input shift_ena,
    input count_ena,
    input [3:0] data,
    output reg [3:0] q
);

always @(posedge clk) begin
    if (count_ena) begin
        q <= q - 1;
    end else if (shift_ena) begin
        q <= {data, q[3:1]};
    end
    
end




endmodule
