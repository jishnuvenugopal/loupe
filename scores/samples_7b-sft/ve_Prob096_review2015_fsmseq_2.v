
module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    parameter IDLE = 3'b000,
              S1 = 3'b001,
              S2 = 3'b010,
              S3 = 3'b011,
              DONE = 3'b100;

    reg [2:0] current_state, next_state;

    
    always @(posedge clk) begin
        if (reset)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1:   next_state = data ? S2 : IDLE;
            S2:   next_state = data ? S2 : S3;
            S3:   next_state = data ? DONE : IDLE;
            DONE: next_state = DONE;
            default: next_state = IDLE;
        endcase
    end

    
    assign start_shifting = (current_state == DONE);

endmodule
