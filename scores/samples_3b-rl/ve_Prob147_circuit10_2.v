
module TopModule (
    input clk,
    input a,
    input b,
    output reg state,
    output reg q
);

always @(posedge clk) begin
    state <= a;
    if (b == 1) begin
        q <= b;
    end
    
end




endmodule
