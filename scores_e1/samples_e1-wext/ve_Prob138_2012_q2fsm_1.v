
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state = A;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (w) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    if (w) begin
                        state <= C;
                    end else begin
                        state <= D;
                    end
                end
                C: begin
                    if (w) begin
                        state <= E;
                    end else begin
                        state <= D;
                    end
                end
                D: begin
                    if (w) begin
                        state <= F;
                    end else begin
                        state <= A;
                    end
                end
                E: begin
                    if (w) begin
                        state <= E;
                    end else begin
                        state <= D;
                    end
                end
                F: begin
                    if (w) begin
                        state <= C;
                    end else begin
                        state <= D;
                    end
                end
            endcase
        end
    end

    
    assign z = state == F;

endmodule
