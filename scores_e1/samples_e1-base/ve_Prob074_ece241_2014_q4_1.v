
module TopModule (
    input clk,
    input x,
    output z
);

    
    typedef enum {IDLE, XOR, AND, OR} state_t;

    
    reg [1:0] d_flip_flops[2];

    
    reg xnor_output;

    
    state_t state;

    
    always @(posedge clk) begin
        case (state)
            IDLE: begin
                if (x) begin
                    state <= XOR;
                end else begin
                    state <= IDLE;
                end
            end
            XOR: begin
                d_flip_flops[0] <= x;
                d_flip_flops[1] <= ~x;
                xnor_output <= d_flip_flops[0] ^ d_flip_flops[1];
                state <= AND;
            end
            AND: begin
                d_flip_flops[0] <= x;
                d_flip_flops[1] <= ~x;
                xnor_output <= d_flip_flops[0] & d_flip_flops[1];
                state <= OR;
            end
            OR: begin
                d_flip_flops[0] <= x;
                d_flip_flops[1] <= ~x;
                xnor_output <= d_flip_flops[0] | d_flip_flops[1];
                state <= IDLE;
            end
        endcase
    end

    
    assign d_flip_flops[0] = x;
    assign d_flip_flops[1] = ~x;

    
    assign z = xnor_output;

endmodule
