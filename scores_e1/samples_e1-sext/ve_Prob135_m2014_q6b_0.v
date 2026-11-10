
module TopModule (
    input wire y[2:0],
    input wire w,
    output reg Y1
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state;

    
    reg [2:0] state_reg;
    reg [1:0] y_reg;

    
    always @(*) begin
        state = A;
        state_reg = A;
        y_reg = y[1];
    end

    
    always @(posedge w or posedge y[1]) begin
        if (w == 1) begin
            state_reg = state;
            y_reg = y[1];
        end else begin
            case (state)
                A: begin
                    if (y[1] == 0) begin
                        state_reg = A;
                        y_reg = y[1];
                    end else begin
                        state_reg = B;
                        y_reg = y[1];
                    end
                end
                B: begin
                    if (y[1] == 0) begin
                        state_reg = C;
                        y_reg = y[1];
                    end else begin
                        state_reg = D;
                        y_reg = y[1];
                    end
                end
                C: begin
                    if (y[1] == 0) begin
                        state_reg = E;
                        y_reg = y[1];
                    end else begin
                        state_reg = D;
                        y_reg = y[1];
                    end
                end
                D: begin
                    if (y[1] == 0) begin
                        state_reg = F;
                        y_reg = y[1];
                    end else begin
                        state_reg = A;
                        y_reg = y[1];
                    end
                end
                E: begin
                    if (y[1] == 0) begin
                        state_reg = E;
                        y_reg = y[1];
                    end else begin
                        state_reg = D;
                        y_reg = y[1];
                    end
                end
                F: begin
                    if (y[1] == 0) begin
                        state_reg = C;
                        y_reg = y[1];
                    end else begin
                        state_reg = D;
                        y_reg = y[1];
                    end
                end
            endcase
        end
    end

    
    always @(*) begin
        Y1 = y_reg;
    end

endmodule
