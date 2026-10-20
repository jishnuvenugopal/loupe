
module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    
    typedef enum {A, B, C, D} state_t;
    state_t current_state, next_state;

    
    reg [1:0] state_reg;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            current_state <= A;
            state_reg <= A;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) next_state = A;
                else next_state = B;
            end
            B: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
            C: begin
                if (in == 0) next_state = A;
                else next_state = D;
            end
            D: begin
                if (in == 0) next_state = C;
                else next_state = B;
            end
        endcase
    end

    
    assign out = (state_reg == D);

endmodule
