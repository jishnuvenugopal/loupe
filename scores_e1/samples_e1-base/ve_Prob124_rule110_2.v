
module TopModule (
    input clk,
    input load,
    input [511:0] data,
    output [511:0] q
);
    reg [511:0] current_state;
    reg [511:0] next_state;
    reg [511:0] input_data;

    always @(posedge clk) begin
        if (load) begin
            input_data <= data;
            current_state <= input_data;
        end else begin
            next_state <= current_state;
            for (int i = 0;
 i < 512;
 i++) begin
                if (i == 0) begin
                    next_state[i] = current_state[511] ^ current_state[1];
                end else if (i == 511) begin
                    next_state[i] = current_state[0] ^ current_state[4];
                end else begin
                    next_state[i] = current_state[i-1] ^ current_state[i] ^ current_state[i+1];
                end
            end
            current_state <= next_state;
        end
    end

    assign q = current_state;
endmodule
