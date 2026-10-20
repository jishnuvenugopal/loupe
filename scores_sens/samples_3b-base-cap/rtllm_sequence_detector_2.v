
module sequence_detector (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg sequence_detected
);

    
    typedef enum {IDLE, S1, S2, S3, S4} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (data_in == 1'b1) begin
                    next_state = S1;
                end else begin
                    next_state = IDLE;
                end
            end
            S1: begin
                if (data_in == 1'b0) begin
                    next_state = S2;
                end else begin
                    next_state = IDLE;
                end
            end
            S2: begin
                if (data_in == 1'b0) begin
                    next_state = S3;
                end else begin
                    next_state = IDLE;
                end
            end
            S3: begin
                if (data_in == 1'b1) begin
                    next_state = S4;
                end else begin
                    next_state = IDLE;
                end
            end
            S4: begin
                if (data_in == 1'b0) begin
                    next_state = IDLE;
                end else begin
                    next_state = S4;
 
                end
            end
            default: begin
                next_state = IDLE;
 
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            S4: begin
                sequence_detected = 1'b1;
            end
            default: begin
                sequence_detected = 1'b0;
            end
        endcase
    end

endmodule
