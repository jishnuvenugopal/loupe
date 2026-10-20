
module TopModule (
    input wire rst,
    input wire clk,
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;
    state_t current_state, next_state;

    
    reg [2:0] y;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_state <= A;
            y <= 3'b000;
        end else begin
            current_state <= next_state;
            case (current_state)
                A: begin
                    if (w) begin
                        next_state <= A;
                    end else begin
                        next_state <= B;
                    end
                end
                B: begin
                    if (w) begin
                        next_state <= C;
                    end else begin
                        next_state <= D;
                    end
                end
                C: begin
                    if (w) begin
                        next_state <= E;
                    end else begin
                        next_state <= D;
                    end
                end
                D: begin
                    if (w) begin
                        next_state <= F;
                    end else begin
                        next_state <= A;
                    end
                end
                E: begin
                    if (w) begin
                        next_state <= E;
                    end else begin
                        next_state <= D;
                    end
                end
                F: begin
                    if (w) begin
                        next_state <= C;
                    end else begin
                        next_state <= D;
                    end
                end
            endcase
        end
    end

    
    assign Y1 = y[1];

endmodule
