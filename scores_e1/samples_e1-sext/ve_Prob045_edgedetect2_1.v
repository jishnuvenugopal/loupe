
module TopModule (
    input clk,
    input in      (8 bits),
    input anyedge (8 bits),
    output reg [7:0] out
);

    reg [7:0] current_state;
    reg [7:0] next_state;
    reg [7:0] transition_count;

    always @(posedge clk) begin
        
        current_state <= in;

        
        if (current_state != next_state) begin
            transition_count <= transition_count + 1;
        end

        
        if (transition_count == 1) begin
            out <= next_state;
            transition_count <= 0;
        end
    end

endmodule
