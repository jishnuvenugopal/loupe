
module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    
    typedef enum {IDLE, STATE1, STATE2} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
    end

    
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            current_state <= IDLE;
            z <= 1'b0;
        end else begin
            current_state <= next_state;
            case (current_state)
                IDLE: begin
                    if (x) begin
                        next_state = STATE1;
                    end else begin
                        next_state = IDLE;
                    end
                end
                STATE1: begin
                    if (x) begin
                        next_state = STATE2;
                    end else begin
                        next_state = IDLE;
                    end
                end
                STATE2: begin
                    if (x) begin
                        next_state = IDLE;
                    end else begin
                        next_state = IDLE;
                    end
                end
            endcase
            
            z <= (current_state == IDLE) ? 1'b0 : 1'b1;
        end
    end

endmodule
