
module TopModule(
    input clk,
    input reset,
    input data,
    output reg start_shifting
);


localparam S0 = 3'd0;
localparam S1 = 3'd1;
localparam S2 = 3'd2;
localparam S3 = 3'd3;
localparam S_DONE = 3'd4;

reg [2:0] current_state, next_state;


always @(posedge clk) begin
    if (reset)
        current_state <= S0;
    else
        current_state <= next_state;
end


always @* begin
    case (current_state)
        S0: next_state = data ? S1 : S0;
        S1: next_state = data ? S2 : S0;
        S2: next_state = data ? S2 : S3;
        S3: next_state = data ? S_DONE : S0;
        S_DONE: next_state = S_DONE;
        default: next_state = S0;
    endcase
end


always @* begin
    start_shifting = (current_state == S_DONE);
end

endmodule
