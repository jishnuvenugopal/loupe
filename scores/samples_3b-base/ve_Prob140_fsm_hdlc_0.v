
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output disc,
    output flag,
    output err
);

    
    typedef enum {IDLE, ONE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, ERROR} state_t;
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
                if (in) begin
                    next_state <= ONE;
                end else begin
                    next_state <= IDLE;
                end
            end
            ONE: begin
                if (in) begin
                    next_state <= TWO;
                end else begin
                    next_state <= IDLE;
                end
            end
            TWO: begin
                if (in) begin
                    next_state <= THREE;
                end else begin
                    next_state <= IDLE;
                end
            end
            THREE: begin
                if (in) begin
                    next_state <= FOUR;
                end else begin
                    next_state <= IDLE;
                end
            end
            FOUR: begin
                if (in) begin
                    next_state <= FIVE;
                end else begin
                    next_state <= IDLE;
                end
            end
            FIVE: begin
                if (in) begin
                    next_state <= SIX;
                end else begin
                    next_state <= IDLE;
                end
            end
            SIX: begin
                if (in) begin
                    next_state <= SEVEN;
                end else begin
                    next_state <= IDLE;
                end
            end
            SEVEN: begin
                if (in) begin
                    next_state <= ERROR;
                end else begin
                    next_state <= IDLE;
                end
            end
            ERROR: begin
                next_state <= ERROR;
            end
        endcase
    end

    
    always @(current_state) begin
        disc <= (current_state == SEVEN);
        flag <= (current_state == SIX);
        err <= (current_state == ERROR);
    end

endmodule
