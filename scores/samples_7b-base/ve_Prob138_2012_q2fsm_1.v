
module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

    
    typedef enum reg [1:0] {
        A = 2'b00,
        B = 2'b01,
        C = 2'b10,
        D = 2'b11,
        E = 2'b100,
        F = 2'b101
    } state_t, next_state_t;

    state_t current_state, next_state;

    
    always @(*) begin
        case (current_state)
            A: begin
                if (w) next_state = B;
                else    next_state = A;
            end
            B: begin
                if (w) next_state = C;
                else    next_state = D;
            end
            C: begin
                if (w) next_state = E;
                else    next_state = D;
            end
            D: begin
                if (w) next_state = F;
                else    next_state = A;
            end
            E: begin
                if (w) next_state = E;
                else    next_state = D;
            end
            F: begin
                if (w) next_state = C;
                else    next_state = D;
            end
            default: next_state = A;
 
        endcase
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    
    always @(*) begin
        case (current_state)
            A: z = 1'b0;
            B: z = 1'b0;
            C: z = 1'b1;
            D: z = 1'b0;
            E: z = 1'b1;
            F: z = 1'b1;
        endcase
    end

endmodule
