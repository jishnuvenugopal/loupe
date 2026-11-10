
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    typedef enum {A, B, C, D} state_t;

    
    state_t current_state;

    
    reg [2:0] state_reg;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            state_reg <= A;
        end else begin
            case (current_state)
                A: begin
                    if (r == 3'b000) begin
                        state_reg <= A;
                    end else if (r == 3'b001) begin
                        state_reg <= B;
                    end else if (r == 3'b010) begin
                        state_reg <= C;
                    end else if (r == 3'b011) begin
                        state_reg <= D;
                    end
                end
                B: begin
                    if (r == 3'b001) begin
                        state_reg <= B;
                    end else if (r == 3'b010) begin
                        state_reg <= A;
                    end else if (r == 3'b011) begin
                        state_reg <= C;
                    end
                end
                C: begin
                    if (r == 3'b011) begin
                        state_reg <= C;
                    end else if (r == 3'b010) begin
                        state_reg <= A;
                    end else if (r == 3'b001) begin
                        state_reg <= B;
                    end
                end
                D: begin
                    if (r == 3'b011) begin
                        state_reg <= D;
                    end else if (r == 3'b010) begin
                        state_reg <= A;
                    end else if (r == 3'b001) begin
                        state_reg <= B;
                    end
                end
            endcase
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            g <= 3'b000;
        end else begin
            case (current_state)
                A: begin
                    g <= 3'b000;
                end
                B: begin
                    g <= 3'b001;
                end
                C: begin
                    g <= 3'b010;
                end
                D: begin
                    g <= 3'b011;
                end
            endcase
        end
    end

endmodule
