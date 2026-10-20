
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    
    typedef enum {A, B, C, D, E} state_t;
    state_t state;

    
    reg f_reg;
    reg g_reg;

    
    assign f = f_reg;
    assign g = g_reg;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end else begin
            case (state)
                A: begin
                    state <= B;
                    f_reg <= 1'b1;
                    g_reg <= 1'b0;
                end
                B: begin
                    state <= C;
                    f_reg <= 1'b0;
                    g_reg <= 1'b0;
                end
                C: begin
                    if (x) begin
                        state <= D;
                        g_reg <= 1'b1;
                    end else begin
                        state <= C;
                        g_reg <= 1'b0;
                    end
                end
                D: begin
                    if (y) begin
                        state <= E;
                        g_reg <= 1'b1;
                    end else begin
                        state <= E;
                        g_reg <= 1'b0;
                    end
                end
                E: begin
                    state <= E;
                    g_reg <= g_reg;
                end
                default: begin
                    state <= A;
                    f_reg <= 1'b0;
                    g_reg <= 1'b0;
                end
            endcase
        end
    end

endmodule
