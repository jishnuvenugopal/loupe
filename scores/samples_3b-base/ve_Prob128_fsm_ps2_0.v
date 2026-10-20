
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(current_state, in) begin
        case (current_state)
            IDLE: begin
                if (in[3]) begin
                    next_state <= BYTE1;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE1: begin
                if (in[3]) begin
                    next_state <= BYTE2;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE2: begin
                if (in[3]) begin
                    next_state <= BYTE3;
                end else begin
                    next_state <= IDLE;
                end
            end
            BYTE3: begin
                if (in[3]) begin
                    next_state <= IDLE;
                    done <= 1'b1;
                end else begin
                    next_state <= IDLE;
                end
            end
            default: begin
                next_state <= IDLE;
            end
        endcase
    end

    
    assign done = (current_state == BYTE3);

endmodule
