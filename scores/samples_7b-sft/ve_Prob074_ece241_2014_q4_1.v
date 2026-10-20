
module TopModule (
    input clk,
    input x,
    output z
);
    reg QXOR, QAND, QOR;

    initial begin
        QXOR = 0;
        QAND = 0;
        QOR = 0;
    end

    always @(posedge clk) begin
        QXOR <= x ^ QXOR;
    end

    always @(posedge clk) begin
        QAND <= x & (~QAND);
    end

    always @(posedge clk) begin
        QOR <= x | (~QOR);
    end

    assign z = ~(QXOR ^ QAND ^ QOR);
endmodule
