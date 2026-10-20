
module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] pedge
);

    reg [7:0] in_prev;
    reg [7:0] pedge_reg;

    always @(posedge clk) begin
        in_prev <= in;
    end

    always @(negedge clk) begin
        if (in_prev[0] == 1'b0 && in[0] == 1'b1) pedge_reg[0] <= 1'b1;
        if (in_prev[1] == 1'b0 && in[1] == 1'b1) pedge_reg[1] <= 1'b1;
        if (in_prev[2] == 1'b0 && in[2] == 1'b1) pedge_reg[2] <= 1'b1;
        if (in_prev[3] == 1'b0 && in[3] == 1'b1) pedge_reg[3] <= 1'b1;
        if (in_prev[4] == 1'b0 && in[4] == 1'b1) pedge_reg[4] <= 1'b1;
        if (in_prev[5] == 1'b0 && in[5] == 1'b1) pedge_reg[5] <= 1'b1;
        if (in_prev[6] == 1'b0 && in[6] == 1'b1) pedge_reg[6] <= 1'b1;
        if (in_prev[7] == 1'b0 && in[7] == 1'b1) pedge_reg[7] <= 1'b1;
        pedge <= pedge_reg;
    end

endmodule
