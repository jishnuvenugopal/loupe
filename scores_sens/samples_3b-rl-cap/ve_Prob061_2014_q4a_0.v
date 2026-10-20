
module TopModule (
    input  wire clk,
    input  wire w,
    input  wire R, 
    input  wire E, 
    input  wire L, 
    output wire Q
);

    reg Q_reg;

    always @(posedge clk) begin
        if (L) begin
            Q_reg <= w;
        end else if (E) begin
            Q_reg <= {Q_reg[0], w};
        end else if (R) begin
            Q_reg <= w;
        end
    end

    assign Q = Q_reg;

endmodule
