
module instr_reg (
    input wire clk,
    input wire rst,
    input wire [1:0] fetch,
    input wire [7:0] data,
    output reg [2:0] ins,
    output reg [4:0] ad1,
    output reg [7:0] ad2
);

reg [7:0] ins_p1 = 0;
reg [7:0] ins_p2 = 0;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ins_p1 <= 0;
        ins_p2 <= 0;
    end else begin
        if (fetch == 2'b01) begin
            ins_p1 <= data;
        end else if (fetch == 2'b10) begin
            ins_p2 <= data;
        end else begin
            ins_p1 <= ins_p1;
            ins_p2 <= ins_p2;
        end
    end
end

assign ins = ins_p1[2:0];
assign ad1 = ins_p1[4:0];
assign ad2 = ins_p2[7:0];

endmodule
