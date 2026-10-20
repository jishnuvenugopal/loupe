
module TopModule (
    input  clk,
    input  x,
    output z
);

    
    typedef enum { XOR, AND, OR } state_t;
    state_t current_state, next_state;

    
    reg [0:0] xor_output, and_output, or_output;

    
    initial begin
        xor_output = 0;
        and_output = 0;
        or_output = 0;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;

        
        case (current_state)
            XOR: begin
                xor_output <= x;
                next_state <= AND;
            end
            AND: begin
                and_output <= ~xor_output;
                next_state <= OR;
            end
            OR: begin
                or_output <= ~and_output;
                next_state <= XOR;
            end
        endcase
    end

    
    assign z = ~ (xor_output | and_output | or_output);

endmodule
