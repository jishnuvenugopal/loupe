
module ring_counter (
    input wire clk,
    input wire reset,
    output reg [7:0] out
);


reg [7:0] current_state;


always @(posedge reset) begin
    current_state <= 8'b0000_0001;
end


always @(posedge clk) begin
    if (reset) begin
        current_state <= 8'b0000_0001;
 
    end else begin
        
        current_state <= current_state << 1;
        
        if (current_state[7]) begin
            current_state[0] = 1;
        end
    end
end


assign out = current_state;

endmodule
