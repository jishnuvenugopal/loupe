
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    reg [1:0] state_reg;
    reg [1:0] next_state_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_reg <= A;
            next_state_reg <= A;
        end else begin
            case (state_reg)
                A: begin
                    if (w) begin
                        next_state_reg <= B;
                    end else begin
                        next_state_reg <= A;
                    end
                end
                B: begin
                    if (w) begin
                        next_state_reg <= C;
                    end else begin
                        next_state_reg <= D;
                    end
                end
                C: begin
                    if (w) begin
                        next_state_reg <= E;
                    end else begin
                        next_state_reg <= D;
                    end
                end
                D: begin
                    if (w) begin
                        next_state_reg <= F;
                    end else begin
                        next_state_reg <= A;
                    end
                end
                E: begin
                    if (w) begin
                        next_state_reg <= E;
                    end else begin
                        next_state_reg <= D;
                    end
                end
                F: begin
                    if (w) begin
                        next_state_reg <= C;
                    end else begin
                        next_state_reg <= D;
                    end
                end
            endcase
        end
    end

    
    assign z = state_reg;

endmodule
