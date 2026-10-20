
module JC_counter (
    input wire clk,
    input wire rst_n,
    output reg [63:0] Q
);


reg [63:0] current_state;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        
        current_state <= 64'b0;
    end else begin
        
        if (current_state[0] == 0) begin
            
            current_state <= {current_state[63:1], 1'b1};
        end else begin
            
            current_state <= {current_state[63:1], 1'b0};
        end
    end
end


assign Q = current_state;

endmodule
