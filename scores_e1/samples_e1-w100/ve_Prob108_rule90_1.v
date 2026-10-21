
module TopModule (
    input clk,
    input load,
    input data (512 bits),
    output q (512 bits)
);

    
    reg [511:0] state;

    
    always @(posedge clk) begin
        if (load) begin
            state <= data;
        end else begin
            state <= next_state(state);
        end
    end

    
    function [511:0] next_state(input [511:0] current_state);
        reg [511:0] next_state;
        for (int i = 0;
 i < 512;
 i++) begin
            if (i == 0) begin
                next_state[i] = current_state[511] ^ current_state[1];
            end else if (i == 511) begin
                next_state[i] = current_state[510] ^ current_state[0];
            end else begin
                next_state[i] = current_state[i-1] ^ current_state[i+1];
            end
        end
        next_state[512] = 0;
 
        next_state[0] = 0;
 
        next_state <= next_state;
    endfunction

    
    assign q = state;

endmodule
