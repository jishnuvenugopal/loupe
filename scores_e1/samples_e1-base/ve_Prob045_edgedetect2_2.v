
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits)
);

    
    reg [7:0] state;

    
    reg [7:0] transition_count;

    
    reg [7:0] output;

    
    always @(posedge clk) begin
        
        state <= in;

        
        transition_count <= transition_count + 1;

        
        if (state == 0 && in == 1) begin
            
            output <= output | (1 << transition_count);
        end
    end

endmodule
