
module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    
    typedef enum {A, B, C} state_t;

    
    state_t state;

    
    reg [2:0] state_ff;

    
    always @(posedge clk or posedge resetn) begin
        if (resetn) begin
            state_ff <= A;
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (r[0] == 1) begin
                        state_ff <= B;
                        state <= B;
                    end else if (r[1] == 1) begin
                        state_ff <= C;
                        state <= C;
                    end else if (r[2] == 1) begin
                        state_ff <= A;
                        state <= A;
                    end
                end
                B: begin
                    if (r[0] == 1) begin
                        state_ff <= B;
                        state <= B;
                    end else if (r[1] == 1) begin
                        state_ff <= A;
                        state <= A;
                    end else if (r[2] == 1) begin
                        state_ff <= A;
                        state <= A;
                    end
                end
                C: begin
                    if (r[0] == 1) begin
                        state_ff <= B;
                        state <= B;
                    end else if (r[1] == 1) begin
                        state_ff <= A;
                        state <= A;
                    end else if (r[2] == 1) begin
                        state_ff <= A;
                        state <= A;
                    end
                end
            endcase
        end
    end

    
    assign g = state_ff;

endmodule
