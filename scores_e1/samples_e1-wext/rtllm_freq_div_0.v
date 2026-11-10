
module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_50, cnt_10, cnt_100;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
        cnt_50 <= 0;
        cnt_10 <= 0;
        cnt_100 <= 0;
    end else begin
        if (cnt_50 == 0) begin
            CLK_50 <= ~CLK_50;
            cnt_50 <= 1;
        end else begin
            cnt_50 <= cnt_50 - 1;
        end

        if (cnt_10 == 0) begin
            CLK_10 <= ~CLK_10;
            cnt_10 <= 4;
        end else begin
            cnt_10 <= cnt_10 - 1;
        end

        if (cnt_100 == 0) begin
            CLK_1 <= ~CLK_1;
            cnt_100 <= 49;
        end else begin
            cnt_100 <= cnt_100 - 1;
        end
    end
end

endmodule
