
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
        case (current_state)
            IDLE: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            ONE: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            TWO: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            THREE: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FOUR: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            FIVE: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            SIX: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b0;
            end
            SEVEN: begin
                disc <= 1'b1;
                flag <= 1'b0;
                err <= 1'b0;
            end
            ERROR: begin
                disc <= 1'b0;
                flag <= 1'b0;
                err <= 1'b1;
            end
        endcase
    end

endmodule
