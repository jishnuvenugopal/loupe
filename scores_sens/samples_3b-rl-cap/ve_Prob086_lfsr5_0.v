
module TopModule (
    input  wire clk,
    input  wire reset,
    output reg  [4:0] q
);

    
    
    

    always @(posedge clk) begin
        if (reset) begin
            q <= 5'b11111;
        end else begin
            
            
            q <= {q[3:0], q[4] ^ q[2]};
        end
    end

    
    initial begin
        q = 5'b11111;
    end

endmodule
