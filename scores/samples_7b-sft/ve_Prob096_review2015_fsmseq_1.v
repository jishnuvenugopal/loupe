
module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    reg [2:0] current_state, next_state;

    parameter IDLE = 3'd0;
    parameter S1 = 3'd1;
    parameter S2 = 3'd2;
    parameter S3 = 3'd3;
    parameter S4 = 3'd4;

    
    always @(posedge clk) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: next_state = data ? S1 : IDLE;
            S1: next_state = data ? S2 : IDLE;
            S2: next_state = data ? S1 : S3;
            S3: next_state = data ? S4 : IDLE;
            S4: next_state = S4;
            default: next_state = IDLE;
        endcase
    end

    
    assign start_shifting = (current_state == S4);

endmodule
