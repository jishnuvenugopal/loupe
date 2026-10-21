
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);

    
    reg [511:0] state;

    
    reg [2:0] current_state;

    
    reg [2:0] prev_state;

    
    always @(posedge clk) begin
        if (load) begin
            
            state = data;
        end else begin
            
            current_state = state[511] ^ state[510];
            prev_state = state[511] ^ state[512];
            state = current_state ^ prev_state;
        end
    end

    
    assign q = state;

endmodule
