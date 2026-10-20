
module TopModule(
    input  clk,
    input  x,
    output z
);

    
    typedef enum {STATE_XOR, STATE_AND, STATE_OR} state_t;
    state_t current_state, next_state;

    
    reg q_xor, q_and, q_or;

    
    assign z = ~q_xor & ~q_and & ~q_or;

    
    always @(posedge clk) begin
        current_state <= next_state;

        case (current_state)
            STATE_XOR: begin
                q_xor <= x;
                q_and <= ~q_xor;
                q_or <= ~q_xor;
                next_state <= STATE_AND;
            end
            STATE_AND: begin
                q_xor <= ~q_and;
                q_and <= x;
                q_or <= ~q_and;
                next_state <= STATE_OR;
            end
            STATE_OR: begin
                q_xor <= ~q_or;
                q_and <= ~q_or;
                q_or <= x;
                next_state <= STATE_XOR;
            end
        endcase
    end

endmodule
