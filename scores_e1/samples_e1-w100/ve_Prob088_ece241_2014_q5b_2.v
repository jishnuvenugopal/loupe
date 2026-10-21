
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
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (x == 0) begin
                        state <= A;
                        z <= 0;
                    end else begin
                        state <= B;
                        z <= 1;
                    end
                end
                B: begin
                    if (x == 0) begin
                        state <= B;
                        z <= 1;
                    end else begin
                        state <= A;
                        z <= 0;
                    end
                end
            endcase
        end
    end

endmodule
