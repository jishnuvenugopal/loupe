
module TopModule (
    input clk,
    input x,
    output z
);

    typedef enum {IDLE, XOR, AND, OR} state_t;

    state_t state = IDLE;

    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state = XOR;
                end
            end
            XOR: begin
                z = ~x;
                state = AND;
            end
            AND: begin
                z = ~x & x;
                state = OR;
            end
            OR: begin
                z = ~x | x;
                state = IDLE;
            end
        endcase
    end

endmodule
