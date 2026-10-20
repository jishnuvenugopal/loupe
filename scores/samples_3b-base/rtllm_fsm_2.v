
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum {IDLE, STATE1, STATE2, STATE3, STATE4, STATE5, STATE6} state_t;
    state_t current_state, next_state;

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            current_state <= IDLE;
            MATCH <= 0;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            IDLE: begin
                if (IN == 1) begin
                    next_state = STATE1;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE1: begin
                if (IN == 0) begin
                    next_state = STATE2;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE2: begin
                if (IN == 0) begin
                    next_state = STATE3;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE3: begin
                if (IN == 1) begin
                    next_state = STATE4;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE4: begin
                if (IN == 1) begin
                    next_state = STATE5;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE5: begin
                if (IN == 0) begin
                    next_state = STATE6;
                end else begin
                    next_state = IDLE;
                end
            end
            STATE6: begin
                if (IN == 1) begin
                    next_state = IDLE;
                end else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge CLK or posedge RST) begin
        if (RST) begin
            MATCH <= 0;
        end else begin
            if (current_state == STATE5) begin
                MATCH <= 1;
            end else begin
                MATCH <= 0;
            end
        end
    end

endmodule
