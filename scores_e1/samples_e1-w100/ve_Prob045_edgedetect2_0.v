
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge
);

    
    reg [7:0] current_state;
    reg [7:0] previous_state;

    
    always @(posedge clk) begin
        previous_state <= current_state;
        current_state <= in;

        
        for (int i = 0;
 i < 8;
 i++) begin
            if (current_state[i] != previous_state[i]) begin
                anyedge[i] <= 1'b1;
            end else begin
                anyedge[i] <= 1'b0;
            end
        end
    end

    
    always @(posedge clk) begin
        for (int i = 0;
 i < 8;
 i++) begin
            if (current_state[i] == 1'b0 && previous_state[i] == 1'b1) begin
                anyedge[i] <= 1'b1;
            end else begin
                anyedge[i] <= 1'b0;
            end
        end
    end

endmodule
