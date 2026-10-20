
module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);
    reg [2:0] state, next_state;
    localparam IDLE = 0,
               S1 = 1,
               S2 = 2,
               S3 = 3,
               S4 = 4;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    
    always @* begin
        next_state = state;
        case (state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:   next_state = data_in ? S1 : S2;
            S2:   next_state = data_in ? S1 : S3;
            S3:   next_state = data_in ? S4 : IDLE;
            S4:   next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    
    assign sequence_detected = (state == S4);

endmodule
