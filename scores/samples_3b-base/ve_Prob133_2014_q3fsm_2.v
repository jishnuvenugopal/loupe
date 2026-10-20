
module TopModule (
    input  clk,
    input  reset,
    input  s,
    input  w,
    output z
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    reg current_state_reg;

    
    reg z_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            current_state_reg <= A;
            z_reg <= 0;
        end else begin
            
            current_state_reg <= next_state;

            
            case (current_state)
                A: begin
                    if (s == 0) begin
                        next_state <= A;
                    end else begin
                        next_state <= B;
                    end
                end
                B: begin
                    
                    if (w == 1) begin
                        z_reg <= 1;
                    end else begin
                        z_reg <= 0;
                    end
                    
                    next_state <= A;
                end
            endcase
        end
    end

    
    assign z = z_reg;

endmodule
