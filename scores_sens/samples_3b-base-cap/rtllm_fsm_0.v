
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum {IDLE, MATCH1, MATCH2, MATCH3, MATCH4, MATCH5} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = IDLE;
        MATCH = 0;
    end

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= IDLE;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
            MATCH <= (current_state == MATCH5);
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (IN == 1) begin
                    next_state = MATCH1;
                end else begin
                    next_state = IDLE;
                end
            end
            MATCH1: begin
                if (IN == 0) begin
                    next_state = MATCH2;
                end else begin
                    next_state = IDLE;
                end
            end
            MATCH2: begin
                if (IN == 0) begin
                    next_state = MATCH3;
                end else begin
                    next_state = IDLE;
                end
            end
            MATCH3: begin
                if (IN == 1) begin
                    next_state = MATCH4;
                end else begin
                    next_state = IDLE;
                end
            end
            MATCH4: begin
                if (IN == 1) begin
                    next_state = MATCH5;
                end else begin
                    next_state = IDLE;
                end
            end
            MATCH5: begin
                if (IN == 0) begin
                    next_state = MATCH5;
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

endmodule
