
module TopModule (
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

    
    typedef enum {OFF, ON} state_t;
    state_t state, next_state;

    
    reg out;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= OFF;
        end else begin
            state <= next_state;
        end
    end

    
    always @(*) begin
        case (state)
            OFF: begin
                if (j == 1) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
                out = 0;
            end
            ON: begin
                if (k == 1) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
                out = 1;
            end
        endcase
    end

endmodule
