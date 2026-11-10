
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits)
);

    
    reg [7:0] state;
    reg [7:0] transition_count;

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (in[i] != state[i]) begin
                state[i] = in[i];
                transition_count[i] = transition_count[i] + 1;
            end else begin
                transition_count[i] = 0;
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (transition_count[i] == 1) begin
                anyedge[i] = 1;
            end else begin
                anyedge[i] = 0;
            end
        end
    end

endmodule
