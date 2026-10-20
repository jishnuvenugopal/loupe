
module TopModule(
    input  clk,
    input  j,
    input  k,
    output reg Q
);
reg Qold;

always @(posedge clk) begin
    Qold <= Q;
    if (j == 1 && k == 1)
        Q <= ~Qold;
    else if (j == 1)
        Q <= 1;
    else if (k == 1)
        Q <= 0;
    else
        Q <= Qold;
end

endmodule
