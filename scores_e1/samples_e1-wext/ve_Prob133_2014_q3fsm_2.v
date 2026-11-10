
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;

    
    state_t state = A;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
            z <= 0;
        end else begin
            case (state)
                A: begin
                    if (s == 1) begin
                        state <= B;
                    end
                end
                B: begin
                    
                    if (w == 1) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    
                    state <= A;
                end
            endcase
        end
    end

endmodule
