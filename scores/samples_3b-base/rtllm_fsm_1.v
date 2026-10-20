
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum {IDLE, MATCH_FOUND, MATCH_FOUND_2} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
        MATCH = 0;
    end

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state = IDLE;
            MATCH = 0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (IN == 1) begin
                        next_state = MATCH_FOUND;
                    end else begin
                        next_state = IDLE;
                    end
                end
                MATCH_FOUND: begin
                    if (IN == 0) begin
                        next_state = MATCH_FOUND_2;
                    end else begin
                        next_state = IDLE;
                    end
                end
                MATCH_FOUND_2: begin
                    if (IN == 1) begin
                        MATCH = 1;
                        next_state = IDLE;
                    end else begin
                        next_state = IDLE;
                    end
                end
            endcase
        end
    end

endmodule
