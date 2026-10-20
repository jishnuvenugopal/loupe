
module TopModule (
    input  wire clk,
    input  wire resetn,
    input  wire x,
    input  wire y,
    output reg  f,
    output reg  g
);

    
    reg [2:0] x_reg;
    reg [1:0] y_reg;
    reg f_reg;
    reg g_reg;

    
    enum {STATE_A, STATE_B} state;

    always @(posedge clk) begin
        if (!resetn) begin
            f_reg  <= 1'b0;
            g_reg  <= 1'b0;
            x_reg  <= 3'b000;
            y_reg  <= 2'b00;
            state  <= STATE_A;
        end else begin
            case (state)
                STATE_A: begin
                    
                    f_reg  <= 1'b0;
                    g_reg  <= 1'b0;
                    x_reg  <= 3'b000;
                    y_reg  <= 2'b00;
                    state  <= STATE_A;
                end
                STATE_B: begin
                    
                    f_reg  <= 1'b1;
                    g_reg  <= 1'b0;
                    x_reg  <= {x_reg[1:0], x};
                    y_reg  <= {y_reg[0], y};
                    state  <= STATE_B;
                end
            endcase
        end
    end

    
    assign f = f_reg;
    assign g = g_reg;

endmodule
