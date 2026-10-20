
module fsm (
    input wire IN,
    input wire CLK,
    input wire RST,
    output reg MATCH
);

    
    typedef enum reg [2:0] {IDLE, STATE1, STATE2, STATE3} state_t;
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
                MATCH = 0;
            end
            STATE1: begin
                if (IN == 0) begin
                    next_state = STATE2;
                end else begin
                    next_state = IDLE;
                end
                MATCH = 0;
            end
            STATE2: begin
                if (IN == 0) begin
                    next_state = STATE3;
                end else begin
                    next_state = IDLE;
                end
                MATCH = 0;
            end
            STATE3: begin
                if (IN == 1) begin
                    next_state = STATE3;
 
                end else if (IN == 0) begin
                    next_state = IDLE;
                end else begin
                    next_state = IDLE;
                end
                MATCH = 1;
            end
            default: begin
                next_state = IDLE;
                MATCH = 0;
            end
        endcase
    end

endmodule
