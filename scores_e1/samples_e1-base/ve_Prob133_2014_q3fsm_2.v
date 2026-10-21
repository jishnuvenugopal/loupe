
module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

    
    typedef enum {A, B} state_t;
    state_t current_state = A;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= A;
            z <= 0;
        end else begin
            case (current_state)
                A: begin
                    if (s == 1) begin
                        current_state <= B;
                    end
                end
                B: begin
                    
                    if (w == 1) begin
                        z <= 1;
                    end else begin
                        z <= 0;
                    end
                    
                    if (clk == 1) begin
                        current_state <= A;
                    end
                end
            endcase
        end
    end

endmodule
