
module TopModule(
    input  clk,
    input  x,
    output z
);

    
    typedef enum {STATE_0, STATE_1, STATE_2} state_t;
    state_t current_state, next_state;

    
    reg d0, d1, d2;

    
    wire xor_out, and_out, or_out;
    wire xor_in0, xor_in1;
    wire and_in0, and_in1;
    wire or_in0, or_in1;

    
    wire xnor_out;

    
    initial begin
        current_state = STATE_0;
    end

    
    always @(posedge clk) begin
        current_state <= next_state;

        
        case (current_state)
            STATE_0: begin
                xor_in0 = x;
                xor_in1 = d0;
                and_in0 = ~d0;
                and_in1 = ~d1;
                or_in0 = ~d0;
                or_in1 = ~d1;
                next_state = STATE_1;
            end
            STATE_1: begin
                xor_in0 = d0;
                xor_in1 = d1;
                and_in0 = ~d1;
                and_in1 = ~d2;
                or_in0 = ~d1;
                or_in1 = ~d2;
                next_state = STATE_2;
            end
            STATE_2: begin
                xor_in0 = d1;
                xor_in1 = d2;
                and_in0 = ~d2;
                and_in1 = ~d0;
                or_in0 = ~d2;
                or_in1 = ~d0;
                next_state = STATE_0;
            end
        endcase

        
        xor_out = xor(xor_in0, xor_in1);
        and_out = and(and_in0, and_in1);
        or_out = or(or_in0, or_in1);

        
        xnor_out = xnor(xor_out, and_out, or_out);

        
        d0 <= xor_out;
        d1 <= and_out;
        d2 <= or_out;
    end

    
    assign z = xnor_out;

endmodule
