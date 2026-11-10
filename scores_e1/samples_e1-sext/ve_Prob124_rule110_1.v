
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output reg [511:0] q
);

    reg [511:0] current_state;
    reg [511:0] next_state;

    always @(posedge clk) begin
        if (load) begin
            current_state <= data;
            next_state <= 512'b0;
        end else begin
            next_state <= current_state;
            for (int i = 0;
 i < 512;
 i++) begin
                if (i == 0) begin
                    next_state[i] = current_state[511] ^ current_state[1] ^ current_state[2];
                end else if (i == 511) begin
                    next_state[i] = current_state[510] ^ current_state[4] ^ current_state[3];
                end else begin
                    next_state[i] = current_state[i-1] ^ current_state[i] ^ current_state[i+1];
                end
            end
        end
        q <= next_state;
    end

endmodule
