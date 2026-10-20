
module TopModule(
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum reg [1:0] {A, B, C, D} state_t;
    state_t current_state, next_state;

    
    always @(posedge clk or posedge areset) begin
        if (areset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    
    always @* begin
        case (current_state)
            A: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = A;
            end
            B: begin
                if (in == 0)
                    next_state = B;
                else
                    next_state = C;
            end
            C: begin
                if (in == 0)
                    next_state = A;
                else
                    next_state = D;
            end
            D: begin
                if (in == 0)
                    next_state = C;
                else
                    next_state = B;
            end
            default: begin
                next_state = A;
            end
        endcase
    end

    
    always @(*) begin
        case (current_state)
            A: out = 0;
            B: out = 0;
            C: out = 0;
            D: out = 1;
        endcase
    end

endmodule
