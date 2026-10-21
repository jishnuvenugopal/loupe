
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    typedef enum {A, B, C} state_t;
    state_t current_state, next_state;

    
    reg [2:0] state_reg;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            state_reg <= A;
        end else begin
            current_state <= next_state;
            state_reg <= current_state;
        end
    end

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            next_state <= A;
        end else begin
            case (current_state)
                A: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= C;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                B: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                C: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
                    end
                end
                D: begin
                    if (r[0] == 1) begin
                        next_state <= B;
                    end else if (r[1] == 1) begin
                        next_state <= A;
                    end else if (r[2] == 1) begin
                        next_state <= D;
                    end else begin
                        next_state <= A;
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
