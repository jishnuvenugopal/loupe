
module TopModule (
    input  clk,
    input  x,
    output z
);

    
    typedef enum {IDLE, XOR, AND, OR, FINAL} state_t;
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

    
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                next_state = XOR;
            end
            XOR: begin
                next_state = AND;
            end
            AND: begin
                next_state = OR;
            end
            OR: begin
                next_state = FINAL;
            end
            FINAL: begin
                next_state = IDLE;
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                d_ff_xor <= 0;
                d_ff_and <= 0;
                d_ff_or <= 0;
            end
            XOR: begin
                d_ff_xor <= x ^ d_ff_xor;
            end
            AND: begin
                d_ff_and <= x & ~d_ff_xor;
            end
            OR: begin
                d_ff_or <= x | ~d_ff_xor;
            end
            FINAL: begin
                z <= d_ff_xor ^ d_ff_and ^ d_ff_or;
            end
            default: begin
                d_ff_xor <= 0;
                d_ff_and <= 0;
                d_ff_or <= 0;
            end
        endcase
    end

endmodule
