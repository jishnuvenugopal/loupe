
module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

    reg Q;
    wire Qold;

    always @(posedge clk) begin
        if (j == 0 && k == 0) begin
            Q <= Qold;
        end
        else if (j == 0 && k == 1) begin
            Q <= 1'b0;
        end
        else if (j == 1 && k == 0) begin
            Q <= 1'b1;
        end
        else if (j == 1 && k == 1) begin
            Q <= ~Qold;
        end
    end

    assign Qold = Q;

endmodule
