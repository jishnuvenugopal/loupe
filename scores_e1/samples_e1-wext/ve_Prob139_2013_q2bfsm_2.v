
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {state_A, state_B, state_C} state_t;

    
    state_t state = state_A;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= state_A;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                state_A: begin
                    f <= 0;
                    g <= 0;
                    if (x == 1) begin
                        state <= state_B;
                    end
                end
                state_B: begin
                    f <= 1;
                    g <= 0;
                    if (x == 0) begin
                        state <= state_C;
                    end
                end
                state_C: begin
                    f <= 1;
                    g <= 1;
                    if (y == 1) begin
                        state <= state_C;
                    end
                    else begin
                        state <= state_A;
                    end
                end
            endcase
        end
    end

endmodule
