
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    
    typedef enum { A, B, C, D } state_t;
    state_t current_state, next_state;

    
    reg current_state_reg;

    
    initial begin
        current_state_reg = A;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state_reg <= A;
 
        end else begin
            current_state_reg <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = B;
                end else begin
                    next_state = C;
                end
            end
            C: begin
                if (in == 0) begin
                    next_state = A;
                end else begin
                    next_state = D;
                end
            end
            D: begin
                if (in == 0) begin
                    next_state = C;
                end else begin
                    next_state = B;
                end
            end
        endcase
    end

    
    assign out = (current_state == D) ? 1'b1 : 1'b0;

endmodule
