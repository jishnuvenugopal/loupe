
module TopModule (
    input clk,
    input areset,
    input x,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state = A;

    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (x == 0) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
                B: begin
                    if (x == 0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    assign z = state == B;

endmodule
