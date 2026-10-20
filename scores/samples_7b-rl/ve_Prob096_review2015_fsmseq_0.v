
module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] state, next_state;

    localparam S_IDLE = 3'd0,
               S1 = 3'd1,
               S2 = 3'd2,
               S3 = 3'd3,
               S_DONE = 3'd4;

    
    always @(posedge clk) begin
        if (reset)
            state <= S_IDLE;
        else
            state <= next_state;
    end

    
    always @* begin
        case (state)
            S_IDLE: next_state = data ? S1 : S_IDLE;
            S1:     next_state = data ? S2 : S_IDLE;
            S2:     next_state = (data == 0) ? S3 : S2;
            S3:     next_state = data ? S_DONE : S_IDLE;
            S_DONE: next_state = S_DONE;
            default: next_state = S_IDLE;
        endcase
    end

    
    assign start_shifting = (state == S_DONE);

endmodule
