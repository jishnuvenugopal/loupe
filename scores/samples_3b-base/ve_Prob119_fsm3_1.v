
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum {A, B, C, D} state_t;
    state_t current_state, next_state;

    
    reg current_state_reg;

    
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
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
                out = 0;
            end
            B: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = C;
                end
                out = 0;
            end
            C: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = D;
                end
                out = 0;
            end
            D: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
                out = 1;
            end
        endcase
    end

    
    assign out = current_state_reg;

endmodule
