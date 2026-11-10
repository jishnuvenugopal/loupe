
module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

    
    typedef enum {A, B, C} state_t;
    state_t state = A;

    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state <= A;
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    if (resetn) begin
                        state <= A;
                        f <= 0;
                        g <= 0;
                    end else begin
                        f <= 0;
                        g <= 0;
                    end
                end
                B: begin
                    if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 0) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end
                end
                C: begin
                    if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 0) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            f <= 0;
            g <= 0;
        end else begin
            case (state)
                A: begin
                    if (resetn) begin
                        f <= 0;
                        g <= 0;
                    end else begin
                        f <= 0;
                        g <= 0;
                    end
                end
                B: begin
                    if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 0) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end
                end
                C: begin
                    if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 0) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else if (x == 1) begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end else begin
                        state <= B;
                        f <= 0;
                        g <= 0;
                    end
                end
            endcase
        end
    end

endmodule
