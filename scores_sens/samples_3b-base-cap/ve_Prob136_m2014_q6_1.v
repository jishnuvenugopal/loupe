
module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = A;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (w) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            B: begin
                if (w) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
            C: begin
                if (w) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (w) begin
                    next_state = F;
                end else begin
                    next_state = A;
                end
            end
            E: begin
                if (w) begin
                    next_state = E;
                end else begin
                    next_state = D;
                end
            end
            F: begin
                if (w) begin
                    next_state = C;
                end else begin
                    next_state = D;
                end
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            A: z = 0;
            B: z = 0;
            C: z = 0;
            D: z = 0;
            E: z = 1;
            F: z = 1;
        endcase
    end

endmodule
