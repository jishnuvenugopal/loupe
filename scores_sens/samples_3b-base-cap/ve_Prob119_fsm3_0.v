
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum {A, B, C, D} state_t;

    
    state_t current_state, next_state;

    
    initial current_state = A;

    
    always @(posedge areset) begin
        current_state <= A;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;
    end

    
    always @(current_state, in) begin
        case (current_state)
            A: begin
                if (in == 0) next_state = A;
                else next_state = B;
                out = 0;
            end
            B: begin
                if (in == 0) next_state = C;
                else next_state = B;
                out = 0;
            end
            C: begin
                if (in == 0) next_state = A;
                else next_state = D;
                out = 0;
            end
            D: begin
                if (in == 0) next_state = C;
                else next_state = B;
                out = 1;
            end
        endcase
    end

endmodule
