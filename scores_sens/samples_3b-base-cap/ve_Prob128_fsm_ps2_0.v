
module TopModule (
    input  clk,
    input  reset,
    input  [7:0] in,
    output reg done
);

    
    typedef enum {IDLE, BYTE1, BYTE2, BYTE3, DONE} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= IDLE;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
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
                    next_state <= DONE;
                end else begin
                    next_state <= IDLE;
                end
            end
            DONE: begin
                next_state <= IDLE;
            end
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            done <= 0;
        end else begin
            case (current_state)
                BYTE3: begin
                    done <= 1;
                end
                default: begin
                    done <= 0;
                end
            endcase
        end
    end

endmodule
