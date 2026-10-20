
module TopModule (
    input  wire clk,
    input  wire j,
    input  wire k,
    output reg  Q
);

    reg Qold;

    always @(posedge clk) begin
        Qold <= Q;
        if (j == 1'b0 && k == 1'b0)
            Q <= Qold;
        else if (j == 1'b0 && k == 1'b1)
            Q <= 1'b0;
        else if (j == 1'b1 && k == 1'b0)
            Q <= 1'b1;
        else if (j == 1'b1 && k == 1'b1)
            Q <= ~Qold;
    end

endmodule
