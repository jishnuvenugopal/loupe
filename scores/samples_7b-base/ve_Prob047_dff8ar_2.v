
module TopModule (
    input clk,
    input areset,
    input [7:0] d,
    output reg [7:0] q
);

    reg [2:0] dff_addr;
    reg [7:0] dff_reg [7:0];

    always @(posedge clk or posedge areset) begin
        if (areset)
            q <= 8'b0;
        else
            q <= dff_reg[dff_addr];
    end

    always @(posedge clk) begin
        dff_reg[dff_addr] <= d;
        if (dff_addr == 3'd7)
            dff_addr <= 3'b0;
        else
            dff_addr <= dff_addr + 1'b1;
    end

endmodule
