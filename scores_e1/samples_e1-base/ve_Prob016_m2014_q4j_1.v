
module TopModule (
    input wire [3:0] x,  
    input wire [3:0] y,  
    output reg [4:0] sum  
);


always @(posedge clk or negedge rst) begin
    if (rst) begin
        sum <= 5'b00000;
    end else begin
        sum[4] <= x[3] ^ y[3] ^ carry[3];
        sum[3] <= (x[3] & y[3]) | (x[3] & carry[3]) | (y[3] & carry[3]);
        sum[2] <= x[2] ^ y[2] ^ carry[2];
        sum[1] <= (x[2] & y[2]) | (x[2] & carry[2]) | (y[2] & carry[2]);
        sum[0] <= x[1] ^ y[1] ^ carry[1];
        carry[0] <= (x[1] & y[1]) | (x[1] & carry[1]) | (y[1] & carry[1]);
        carry[1] <= (x[0] & y[0]) | (x[0] & carry[1]) | (y[0] & carry[1]);
        carry[2] <= (x[0] & y[0]) | (x[0] & carry[1]) | (y[0] & carry[1]);
        carry[3] <= (x[0] & y[0]) | (x[0] & carry[1]) | (y[0] & carry[1]);
    end
end

endmodule
