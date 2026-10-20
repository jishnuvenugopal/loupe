
module TopModule (
    input clk,
    input j,
    input k,
    output Q
);

    reg Qreg;

    always @(posedge clk) begin
        if (j == 0 && k == 0) begin
            Qreg <= Qreg;
        end else if (j == 0 && k == 1) begin
            Qreg <= 1'b0;
        end else if (j == 1 && k == 0) begin
            Qreg <= 1'b1;
        end else if (j == 1 && k == 1) begin
            Qreg <= 1'b0;
        end
    end

    assign Q = Qreg;

endmodule
