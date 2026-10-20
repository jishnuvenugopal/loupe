
module TopModule (
    input  clk,
    input  x,
    output z
);

    
    typedef enum {STATE_0, STATE_1, STATE_2, STATE_3, STATE_4} state_t;
    state_t current_state, next_state;

    
    reg y_xor, y_and, y_or;
    reg d_ff_xor, d_ff_and, d_ff_or;

    
    initial begin
        d_ff_xor = 0;
        d_ff_and = 0;
        d_ff_or = 0;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            STATE_0: begin
                next_state = STATE_1;
            end
            STATE_1: begin
                next_state = STATE_2;
            end
            STATE_2: begin
                next_state = STATE_3;
            end
            STATE_3: begin
                next_state = STATE_4;
            end
            STATE_4: begin
                next_state = STATE_0;
            end
            default: begin
                next_state = STATE_0;
            end
        endcase
    end

    
    always @(posedge clk) begin
        case (current_state)
            STATE_0: begin
                
                d_ff_xor = 0;
                d_ff_and = 0;
                d_ff_or = 0;
            end
            STATE_1: begin
                
                y_xor = x ^ d_ff_xor;
                d_ff_xor <= y_xor;
            end
            STATE_2: begin
                
                y_and = x & ~d_ff_xor;
                d_ff_and <= y_and;
            end
            STATE_3: begin
                
                y_or = x | ~d_ff_xor;
                d_ff_or <= y_or;
            end
            STATE_4: begin
                
                z = y_xor ^ y_and ^ y_or;
            end
        endcase
    end

endmodule
