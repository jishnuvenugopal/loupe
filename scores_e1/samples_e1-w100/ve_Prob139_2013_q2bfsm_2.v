
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {A, B, C, D} state_t;
    state_t current_state = A;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            current_state <= A;
            f <= 0;
            g <= 0;
        end else begin
            case (current_state)
                A: begin
                    if (x == 1) begin
                        current_state <= B;
                    end
                end
                B: begin
                    if (x == 0) begin
                        current_state <= C;
                    end
                    if (x == 1) begin
                        current_state <= D;
                    end
                end
                C: begin
                    if (x == 1) begin
                        current_state <= D;
                    end
                end
                D: begin
                    if (y == 1) begin
                        current_state <= B;
                        g <= 1;
                    end
                    if (y == 0) begin
                        current_state <= A;
                        g <= 0;
                    end
                end
            endcase
        end
    end

    
    assign f = current_state == B;
    assign g = current_state == B || current_state == D;

endmodule
