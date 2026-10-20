
module sequence_detector(
    input clk,
    input rst_n,
    input data_in,
    output reg sequence_detected
);

    
    typedef enum reg [2:0] {
        IDLE,
        S1,
        S2,
        S3,
        S4
    } state_t;

    
    state_t state, next_state;

    
    assign sequence_detected = (state == S4);

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        next_state = state;
        case (state)
            IDLE:
                if (data_in == 1'b1) begin
                    next_state = S1;
                end
            S1:
                if (data_in == 1'b0) begin
                    next_state = S2;
                end else begin
                    next_state = IDLE;
                end
            S2:
                if (data_in == 1'b0) begin
                    next_state = S3;
                end else begin
                    next_state = IDLE;
                end
            S3:
                if (data_in == 1'b1) begin
                    next_state = S4;
                end else begin
                    next_state = IDLE;
                end
            S4:
                if (data_in == 1'b0) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
        endcase
    end

endmodule
