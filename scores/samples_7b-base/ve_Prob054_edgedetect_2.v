
module TopModule (
    input wire clk,
    input [7:0] in,
    output reg [7:0] pedge
);

    reg [3:0] in_reg;
    reg [3:0] pedge_reg;
    reg [3:0] edge_det;

    always @(posedge clk) begin
        in_reg <= in[3:0];
        edge_det <= {in_reg[0], in_reg[1], in_reg[2], in_reg[3]};

        if (edge_det == 4'b0001) begin
            pedge_reg <= {1'b1, pedge_reg[3:1]};
        end else begin
            pedge_reg <= {4'b0, pedge_reg[3:1]};
        end
    end

    assign pedge = pedge_reg;

endmodule
