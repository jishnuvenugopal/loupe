
module sequence_detector (
    input clk,
    input rst_n,
    input data_in,
    output sequence_detected
);

    
    localparam IDLE = 3'd0;
    localparam S1 = 3'd1;
    localparam S2 = 3'd2;
    localparam S3 = 3'd3;
    localparam S4 = 3'd4;

    reg [2:0] current_state, next_state;

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            IDLE: next_state = data_in ? S1 : IDLE;
            S1:    next_state = data_in ? S1 : S2;
            S2:    next_state = data_in ? S1 : S3;
            S3:    next_state = data_in ? S4 : IDLE;
            S4:    next_state = data_in ? S1 : IDLE;
            default: next_state = IDLE;
        endcase
    end

    
    assign sequence_detected = (current_state == S4);

endmodule
