
module TopModule (
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    
    typedef enum {STATE_A, STATE_B, STATE_C, STATE_D} state_t;
    state_t current_state, next_state;

    
    reg [3:0] state_reg;

    
    reg f_reg;

    
    reg g_reg;

    
    initial begin
        state_reg <= STATE_A;
        f_reg <= 0;
        g_reg <= 0;
    end

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            state_reg <= STATE_A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            current_state <= state_reg;
            case (current_state)
                STATE_A: begin
                    if (x == 1 && y == 1) begin
                        next_state = STATE_B;
                    end else begin
                        next_state = STATE_A;
                    end
                end
                STATE_B: begin
                    if (x == 1 && y == 1) begin
                        next_state = STATE_C;
                    end else begin
                        next_state = STATE_A;
                    end
                end
                STATE_C: begin
                    if (x == 1 && y == 1) begin
                        next_state = STATE_D;
                    end else begin
                        next_state = STATE_A;
                    end
                end
                STATE_D: begin
                    if (y == 1) begin
                        next_state = STATE_D;
                    end else begin
                        next_state = STATE_A;
                    end
                end
            endcase
            state_reg <= next_state;
            f_reg <= (current_state == STATE_B || current_state == STATE_C || current_state == STATE_D);
            g_reg <= (current_state == STATE_D);
        end
    end

    
    assign f = f_reg;
    assign g = g_reg;

endmodule
