
module TopModule (
    input clk,
    input x,
    output z
);

    
    typedef enum {IDLE, XOR, AND, OR} state_t;

    
    reg [1:0] d_flip_flop_1;
    reg [1:0] d_flip_flop_2;
    reg [1:0] d_flip_flop_3;

    
    reg xnor_output;

    
    state_t state;

    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state <= XOR;
                end
            end
            XOR: begin
                d_flip_flop_1 <= x;
                d_flip_flop_2 <= ~d_flip_flop_1;
                d_flip_flop_3 <= ~d_flip_flop_2;
                xnor_output <= d_flip_flop_1 ^ d_flip_flop_2 ^ d_flip_flop_3;
                state <= AND;
            end
            AND: begin
                d_flip_flop_1 <= x;
                d_flip_flop_2 <= ~d_flip_flop_1;
                d_flip_flop_3 <= ~d_flip_flop_2;
                xnor_output <= d_flip_flop_1 & d_flip_flop_2 & d_flip_flop_3;
                state <= OR;
            end
            OR: begin
                d_flip_flop_1 <= x;
                d_flip_flop_2 <= ~d_flip_flop_1;
                d_flip_flop_3 <= ~d_flip_flop_2;
                xnor_output <= d_flip_flop_1 | d_flip_flop_2 | d_flip_flop_3;
                state <= IDLE;
            end
        endcase
    end

    
    xor_gate xor_gate (
        .a(d_flip_flop_1),
        .b(d_flip_flop_2),
        .c(d_flip_flop_3),
        .y(xnor_output)
    );

    
    output_gate output_gate (
        .a(xnor_output),
        .b(d_flip_flop_1),
        .c(d_flip_flop_2),
        .d(d_flip_flop_3),
        .y(z)
    );

endmodule
