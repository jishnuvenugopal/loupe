
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum {A, B} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = B;
    end

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state = B;
        end else begin
            current_state = next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                out = in;
                next_state = (in == 1'b1) ? B : A;
            end
            B: begin
                out = 1'b0;
                next_state = (in == 1'b1) ? B : A;
            end
        endcase
    end

endmodule
