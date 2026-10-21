
module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_50;
reg [1:0] cnt_10;
reg [1:0] cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_50 <= 2'b00;
        cnt_10 <= 2'b00;
        cnt_100 <= 2'b00;
        CLK_50 <= 1'b0;
        CLK_10 <= 1'b0;
        CLK_1 <= 1'b0;
    end else begin
        cnt_50 <= cnt_50 ^ 1'b1;
        if (cnt_50 == 2'b11) begin
            cnt_50 <= 2'b00;
            CLK_50 <= 1'b1;
        end
        cnt_10 <= cnt_10 ^ 1'b1;
        if (cnt_10 == 2'b11) begin
            cnt_10 <= 2'b00;
            cnt_100 <= 2'b00;
            CLK_10 <= 1'b1;
        end
        cnt_100 <= cnt_100 ^ 1'b1;
        if (cnt_100 == 2'b11) begin
            cnt_100 <= 2'b00;
            CLK_1 <= 1'b1;
        end
    end
end

endmodule
