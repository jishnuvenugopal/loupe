
module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    reg current_state_reg;

    
    initial begin
        current_state_reg = A;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state_reg <= A;
        end else begin
            current_state_reg <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (x == 0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                if (x == 0) begin
                    next_state = B;
                end else begin
                    next_state = B;
                end
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            A: z = 0;
            B: z = 1;
        endcase
    end

endmodule
