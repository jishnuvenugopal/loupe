
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

        
        for (int i = 0;
 i < 8;
 i++) begin
            if (state[i] != state[i-1]) begin
                if (state[i] == 1) begin
                    output[i] <= 1;
                end else begin
                    output[i] <= 0;
                end
            end else begin
                output[i] <= output[i-1];
            end
        end
    end

endmodule
