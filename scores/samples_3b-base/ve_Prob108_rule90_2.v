
module TopModule (
    input  clk,
    input  load,
    input  [511:0] data,
    output [511:0] q
);

    
    reg [511:0] q_next;

    
    always @(posedge clk) begin
        if (load) begin
            
            q <= data;
        end else begin
            
            for (int i = 1;
 i < 511;
 i++) begin
                q_next[i] = q[i-1] ^ q[i+1];
            end
            
            q_next[0] = q[511];
            q_next[511] = q[0];
            
            q <= q_next;
        end
    end

endmodule
