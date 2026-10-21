
module TopModule (
    input clk,
    input x,
    output z
);

    
    typedef enum {IDLE, XOR, AND, OR} state_t;
    state_t state = IDLE;

    
    reg [1:0] d_flip_flop_1;
    reg [1:0] d_flip_flop_2;
    reg [1:0] d_flip_flop_3;

    
    reg [1:0] xor_output;
    reg [1:0] and_output;
    reg [1:0] or_output;

    
    reg [1:0] xnor_output;

    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (x == 1'b1) begin
                    state = XOR;
                end
            end
            XOR: begin
                xor_output = d_flip_flop_1 ^ d_flip_flop_2;
                state = AND;
            end
            AND: begin
                and_output = ~d_flip_flop_1 & d_flip_flop_2;
                state = OR;
            end
            OR: begin
                or_output = ~d_flip_flop_1 | d_flip_flop_2;
                state = XOR;
            end
        endcase
    end

    
    always @(posedge clk) begin
        case (state)
            XOR: begin
                d_flip_flop_1 <= xor_output;
            end
            AND: begin
                d_flip_flop_2 <= and_output;
            end
            OR: begin
                d_flip_flop_3 <= or_output;
            end
        endcase
    end

    
    always @(posedge clk) begin
        xnor_output <= ~d_flip_flop_1 ^ ~d_flip_flop_2 ^ ~d_flip_flop_3;
    end

    
    assign z = xnor_output;

endmodule
