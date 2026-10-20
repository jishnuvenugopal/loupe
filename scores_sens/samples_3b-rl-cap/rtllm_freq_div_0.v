
module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    reg CLK_50, CLK_10, CLK_1;
    reg [3:0] cnt_50, cnt_10, cnt_100;

    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            CLK_50 <= 1'b0;
            CLK_10 <= 1'b0;
            CLK_1 <= 1'b0;
            cnt_50 <= 4'b0000;
            cnt_10 <= 4'b0000;
            cnt_100 <= 5'b00000;
        end else begin
            
            if (cnt_50 == 4'd4) begin
                CLK_50 <= ~CLK_50;
                cnt_50 <= 4'd0;
            end else begin
                cnt_50 <= cnt_50 + 4'd1;
            end

            
            if (cnt_10 == 4'd4) begin
                CLK_10 <= ~CLK_10;
                cnt_10 <= 4'd0;
            end else begin
                cnt_10 <= cnt_10 + 4'd1;
            end

            
            if (cnt_100 == 5'd49) begin
                CLK_1 <= ~CLK_1;
                cnt_100 <= 5'd0;
            end else begin
                cnt_100 <= cnt_100 + 5'd1;
            end
        end
    end

endmodule
