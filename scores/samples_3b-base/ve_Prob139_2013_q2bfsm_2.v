
module TopModule(
    input  clk,
    input  resetn,
    input  x,
    input  y,
    output f,
    output g
);

    
    typedef enum {STATE_A, STATE_B, STATE_C, STATE_D} state_t;
    state_t current_state, next_state;

    
    reg current_state_reg;

    
    reg f_reg;

    
    reg g_reg;

    
    always @(posedge clk or negedge resetn) begin
        if (!resetn) begin
            
            current_state_reg <= STATE_A;
            f_reg <= 0;
            g_reg <= 0;
        end else begin
            
            current_state_reg <= next_state;

            
            case (current_state_reg)
                STATE_A: begin
                    
                    f_reg <= 0;
                    g_reg <= 0;
                end
                STATE_B: begin
                    
                    f_reg <= 1;
                    g_reg <= 0;
                end
                STATE_C: begin
                    
                    if (x) begin
                        next_state <= STATE_D;
                    end
                end
                STATE_D: begin
                    
                    if (y) begin
                        g_reg <= 1;
                        next_state <= STATE_C;
                    end else begin
                        
                        g_reg <= 0;
                        next_state <= STATE_A;
                    end
                end
            endcase
        end
    end

    
    assign f = f_reg;
    assign g = g_reg;

endmodule
