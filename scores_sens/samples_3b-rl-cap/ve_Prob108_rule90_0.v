
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

always @(posedge clk) begin
    if (load) begin
        q <= data;
    end else begin
        
        
        for (integer i = 0;
 i < 512;
 i = i + 1) begin
            q[i] <= q[i-1] ^ q[i] ^ q[i+1];
        end
    end
end






endmodule
