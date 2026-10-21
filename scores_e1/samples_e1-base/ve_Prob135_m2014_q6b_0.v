
module TopModule (
    input wire y [2:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t current_state = A;
    state_t next_state;

    
    reg [2:0] state_reg;
    reg [1:0] y_reg;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= A;
            state_reg <= 3'b000;
            y_reg <= 2'b00;
        end else begin
            case (current_state)
                A: begin
                    if (w == 0) begin
                        next_state = B;
                    end else begin
                        next_state = A;
                    end
                end
                B: begin
                    if (w == 0) begin
                        next_state = C;
                    end else begin
                        next_state = D;
                    end
                end
                C: begin
                    if (w == 0) begin
                        next_state = E;
                    end else begin
                        next_state = D;
                    end
                end
                D: begin
                    if (w == 0) begin
                        next_state = F;
                    end else begin
                        next_state = A;
                    end
                end
                E: begin
                    if (w == 0) begin
                        next_state = E;
                    end else begin
                        next_state = D;
                    end
                end
                F: begin
                    if (w == 0) begin
                        next_state = C;
                    end else begin
                        next_state = D;
                    end
                end
            endcase

            
            state_reg <= next_state;

            
            if (next_state == A || next_state == D || next_state == F) begin
                Y1 <= 1'b1;
            end else begin
                Y1 <= 1'b0;
            end
        end
    end

endmodule
