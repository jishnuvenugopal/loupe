
module freq_div (
    input CLK_in,
    input RST,
    output CLK_50,
    output CLK_10,
    output CLK_1
);

    
    reg cnt_50;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50 <= 0;
            CLK_50 <= 0;
        end else begin
            cnt_50 <= cnt_50 + 1;
            if (cnt_50 == 2) begin
                cnt_50 <= 0;
                CLK_50 <= ~CLK_50;
            end
        end
    end

    
    reg cnt_10;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 0;
            CLK_10 <= 0;
        end else begin
            cnt_10 <= cnt_10 + 1;
            if (cnt_10 == 10) begin
                cnt_10 <= 0;
                CLK_10 <= ~CLK_10;
            end
        end
    end

    
    reg cnt_100;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 0;
            CLK_1 <= 0;
        end else begin
            cnt_100 <= cnt_100 + 1;
            if (cnt_100 == 100) begin
                cnt_100 <= 0;
                CLK_1 <= ~CLK_1;
            end
        end
    end

endmodule
