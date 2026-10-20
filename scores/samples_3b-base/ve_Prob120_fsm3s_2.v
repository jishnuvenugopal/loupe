
module TopModule (
    input  clk,
    input  reset,
    input  in,
    output out
);

    
    typedef enum {A, B, C, D} state_t;
    state_t current_state, next_state;

    
    initial begin
        current_state = A;
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
 
        end else begin
            current_state <= next_state;
        end
    end

    
    always @(*) begin
        case (current_state)
            A: begin
                if (in == 0) begin
                    next_state = A;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 0;
                end
            end
            B: begin
                if (in == 0) begin
                    next_state = C;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 0;
                end
            end
            C: begin
                if (in == 0) begin
                    next_state = A;
                    out = 0;
                end else begin
                    next_state = D;
                    out = 0;
                end
            end
            D: begin
                if (in == 0) begin
                    next_state = C;
                    out = 0;
                end else begin
                    next_state = B;
                    out = 1;
                end
            end
        endcase
    end

endmodule
