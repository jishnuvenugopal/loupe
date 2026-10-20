
module TopModule (
    input  wire clk,
    input  wire shift_ena,
    input  wire count_ena,
    input  wire [3:0] data,
    output reg  [3:0] q
);

always @(posedge clk) begin
    if (shift_ena) begin
        
        q <= {q[2:0], data[3], data[2:0], data[0]};
    end else if (count_ena) begin
        
        q <= q - 1'b1;
    end
    
end




endmodule
