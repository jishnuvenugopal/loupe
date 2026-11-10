
module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    
    typedef enum {A, B, C, D, E, F} state_t;

    
    state_t state;

    
    reg [1:0] state_ff;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_ff <= 2'b00;
            state <= A;
        end else begin
            case (state)
                A: begin
                    if (w) begin
                        state_ff <= 2'b01;
                        state <= B;
                    end else begin
                        state_ff <= 2'b00;
                        state <= A;
                    end
                end
                B: begin
                    if (w) begin
                        state_ff <= 2'b10;
                        state <= C;
                    end else begin
                        state_ff <= 2'b00;
                        state <= D;
                    end
                end
                C: begin
                    if (w) begin
                        state_ff <= 2'b11;
                        state <= E;
                    end else begin
                        state_ff <= 2'b00;
                        state <= D;
                    end
                end
                D: begin
                    if (w) begin
                        state_ff <= 2'b00;
                        state <= A;
                    end else begin
                        state_ff <= 2'b00;
                        state <= D;
                    end
                end
                E: begin
                    if (w) begin
                        state_ff <= 2'b10;
                        state <= E;
                    end else begin
                        state_ff <= 2'b00;
                        state <= D;
                    end
                end
                F: begin
                    if (w) begin
                        state_ff <= 2'b11;
                        state <= C;
                    end else begin
                        state_ff <= 2'b00;
                        state <= D;
                    end
                end
            endcase
        end
    end

    
    assign z = state_ff[1];

endmodule
