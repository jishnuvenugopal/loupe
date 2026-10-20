
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum { A, B, C, D } state_t;

    
    state_t current_state, next_state;

    
    initial begin
        current_state = A;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
 
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                next_state = in ? B : A;
                out = 0;
            end
            B: begin
                next_state = in ? C : B;
                out = 0;
            end
            C: begin
                next_state = in ? A : D;
                out = 0;
            end
            D: begin
                next_state = in ? C : B;
                out = 1;
            end
        endcase
    end

endmodule
