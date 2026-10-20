
module TopModule (
    input clk,
    input a,
    output reg q
);

always @(posedge clk) begin
    if (a)
        q <= ~q;
    
end


initial begin
    q = 1'b0;
end

endmodule
