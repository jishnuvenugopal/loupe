
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {A, B, C, D} state_t;
    state_t state;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    if (x == 1) begin
                        state <= B;
                    end
                end
                B: begin
                    if (x == 0) begin
                        state <= C;
                    end
                    if (x == 1) begin
                        state <= D;
                    end
                end
                C: begin
                    if (x == 1) begin
                        state <= D;
                    end
                end
                D: begin
                    if (x == 1) begin
                        state <= B;
                    end
                    if (y == 1) begin
                        state <= C;
                    end
                    if (y == 0) begin
                        state <= D;
                    end
                end
            endcase
        end
    end

    
    assign f = state == B || state == D;
    assign g = state == C;

endmodule
