
module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R,
    input  wire E,
    input  wire L,
    output reg  Q
);

    reg Q_reg;

    always @(posedge clk) begin
        if (L) begin
            Q_reg <= w;
        end else if (E) begin
            Q_reg <= {w, Q_reg[7:1]};
        end else if (R) begin
            Q_reg <= w;
        end
        
    end

    assign Q = Q_reg;

endmodule
