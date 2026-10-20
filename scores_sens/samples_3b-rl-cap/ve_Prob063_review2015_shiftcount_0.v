
module TopModule (
    input  wire clk,
    input  wire shift_ena,
    input  wire count_ena,
    input  wire [3:0] data,
    output reg  [3:0] q
);

always @(posedge clk) begin
    if (count_ena) begin
        q <= q - 1;
    end else if (shift_ena) begin
        q <= {q[2:0], data};
    end
    
end





endmodule
