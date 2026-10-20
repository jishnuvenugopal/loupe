
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    
    typedef enum {STATE_A, STATE_B, STATE_C, STATE_D} state_t;
    state_t state;

    
    reg f_reg;
    reg g_reg;

    
    wire x1, x2, x3;
    wire y1, y2;

    
    assign x1 = x;
    assign x2 = x1;
    assign x3 = x2;

    
    assign y1 = y;
    assign y2 = y1;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            f_reg <= 1'b0;
            g_reg <= 1'b0;
        end else begin
            case (state)
                STATE_A: begin
                    
                    state <= STATE_B;
                    f_reg <= 1'b1;
                end
                STATE_B: begin
                    
                    state <= STATE_C;
                    f_reg <= 1'b0;
                end
                STATE_C: begin
                    
                    if (x1 && !x2 && x3) begin
                        state <= STATE_D;
                        g_reg <= 1'b1;
                    end else begin
                        state <= STATE_A;
                        g_reg <= 1'b0;
                    end
                end
                STATE_D: begin
                    
                    if (y1 || y2) begin
                        state <= STATE_D;
                        g_reg <= 1'b1;
                    end else begin
                        state <= STATE_A;
                        g_reg <= 1'b0;
                    end
                end
                default: begin
                    state <= STATE_A;
                    f_reg <= 1'b0;
                    g_reg <= 1'b0;
                end
            endcase
        end
    end

    
    assign f = f_reg;
    assign g = g_reg;

endmodule
