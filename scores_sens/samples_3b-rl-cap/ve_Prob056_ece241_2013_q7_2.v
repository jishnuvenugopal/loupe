
module TopModule (
    input  wire clk,
    input  wire j,
    input  wire k,
    output wire Q
);

    reg Qreg;

    always @(posedge clk) begin
        if (j == 1'b0 && k == 1'b0) begin
            Qreg <= Qreg;
        end else if (j == 1'b0 && k == 1'b1) begin
            Qreg <= 1'b0;
        end else if (j == 1'b1 && k == 1'b0) begin
            Qreg <= 1'b1;
        end else if (j == 1'b1 && k == 1'b1) begin
            Qreg <= ~Qreg;
        end
    end

    assign Q = Qreg;

endmodule
