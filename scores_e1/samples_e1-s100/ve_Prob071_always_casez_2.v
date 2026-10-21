
module TopModule (
    input  [7:0] in,  
    output reg [2:0] pos  
);

    
    reg [2:0] state;

    always @(posedge in or posposedge clk) begin
        
        if (posedge clk) begin
            state <= in;
        end

        
        pos <= state;
    end

endmodule
