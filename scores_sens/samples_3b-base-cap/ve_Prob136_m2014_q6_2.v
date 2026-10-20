
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    
    typedef enum {A, B, C, D, E} state_t;
    state_t current_state, next_state;

    
    reg [3:0] state_reg;

    
    initial begin
        state_reg = A;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= A;
        end else begin
            current_state <= state_reg;
            case (current_state)
                A: begin
                    if (w == 0) begin
                        next_state = B;
                    end else begin
                        next_state = A;
                    end
                end
                B: begin
                    if (w == 0) begin
                        next_state = C;
                    end else begin
                        next_state = D;
                    end
                end
                C: begin
                    if (w == 0) begin
                        next_state = E;
                    end else begin
                        next_state = D;
                    end
                end
                D: begin
                    if (w == 0) begin
                        next_state = F;
                    end else begin
                        next_state = A;
                    end
                end
                E: begin
                    if (w == 1) begin
                        next_state = E;
                    end else begin
                        next_state = D;
                    end
                end
                F: begin
                    if (w == 1) begin
                        next_state = C;
                    end else begin
                        next_state = D;
                    end
                end
            endcase
            state_reg <= next_state;
        end
    end

    
    always @(*) begin
        z = (current_state == E);
    end

endmodule
