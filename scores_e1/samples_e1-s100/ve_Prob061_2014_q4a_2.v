
module TopModule (
    input clk,
    input w,
    input R,
    input E,
    input L,
    output Q
);

    reg [7:0] regFile [0:7];

    always @(posedge clk) begin
        if (E && R) begin
            regFile[7] <= w;
        end else if (E) begin
            regFile[7] <= regFile[6];
        end
    end

    assign Q = regFile[0];

endmodule
