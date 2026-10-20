
module TopModule (
    input  wire clk,
    input  wire j,
    input  wire k,
    output reg  Q
);

    reg Qold;

    always @(posedge clk) begin
        if (j == 1'b0 && k == 1'b0) begin
            Q <= Qold;
        end
        else if (j == 1'b0 && k == 1'b1) begin
            Q <= 1'b0;
        end
        else if (j == 1'b1 && k == 1'b0) begin
            Q <= 1'b1;
        end
        else begin
            Q <= ~Qold;
        end
        Qold <= Q;
    end

endmodule
