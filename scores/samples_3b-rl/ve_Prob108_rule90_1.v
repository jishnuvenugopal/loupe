
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
            
            reg [511:0] next_q;
            for (integer i = 0;
 i < 512;
 i = i + 1) begin
                
                
                next_q[i] = (q[i-1] ^ q[i+1]);
            end
            q <= next_q;
        end
    end

endmodule
