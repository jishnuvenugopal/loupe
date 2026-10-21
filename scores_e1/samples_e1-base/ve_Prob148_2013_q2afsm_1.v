
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    
    typedef enum {A, B, C} state_t;

    
    state_t state = A;

    
    reg [2:0] state_reg;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state_reg <= A;
        end else begin
            case (state)
                A: begin
                    if (r == 3'b000) begin
                        state_reg <= A;
                    end else if (r == 3'b001) begin
                        state_reg <= B;
                    end else if (r == 3'b010) begin
                        state_reg <= C;
                    end
                end
                B: begin
                    if (r == 3'b001) begin
                        state_reg <= B;
                    end else if (r == 3'b000) begin
                        state_reg <= A;
                    end
                end
                C: begin
                    if (r == 3'b011) begin
                        state_reg <= C;
                    end else if (r == 3'b000) begin
                        state_reg <= A;
                    end
                end
            endcase
        end
    end

    
    assign g = state_reg;

endmodule
