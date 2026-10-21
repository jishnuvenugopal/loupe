
module TopModule (
    input clk,
    input [7:0] in,
    input [7:0] anyedge,
    output reg [7:0] output,
    output reg count,
    output reg reset
);

    reg [7:0] state;
    reg [7:0] next_state;
    reg [7:0] transition_count;

    always @(posedge clk) begin
        state <= next_state;
        transition_count <= 0;

        for (int i = 0;
 i < 8;
 i++) begin
            if (state[i] == 0 && in[i] == 1) begin
                next_state[i] = 1;
                transition_count++;
            end else if (state[i] == 1 && in[i] == 0) begin
                next_state[i] = 0;
                transition_count = 0;
            end else begin
                next_state[i] = state[i];
            end
        end

        output <= next_state;
        count <= transition_count;
        reset <= 0;
    end

endmodule
