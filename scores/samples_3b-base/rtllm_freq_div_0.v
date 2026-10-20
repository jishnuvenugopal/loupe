
module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

    
    reg [1:0] cnt_50;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_50 <= 2'b00;
            CLK_50 <= 1'b0;
        end else begin
            if (cnt_50 == 2'b11) begin
                cnt_50 <= 2'b00;
                CLK_50 <= ~CLK_50;
            end else begin
                cnt_50 <= cnt_50 + 2'b01;
            end
        end
    end

    
    reg [3:0] cnt_10;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_10 <= 4'b0000;
            CLK_10 <= 1'b0;
        end else begin
            if (cnt_10 == 4'b1111) begin
                cnt_10 <= 4'b0000;
                CLK_10 <= ~CLK_10;
            end else begin
                cnt_10 <= cnt_10 + 4'b0001;
            end
        end
    end

    
    reg [9:0] cnt_100;
    always @(posedge CLK_in or posedge RST) begin
        if (RST) begin
            cnt_100 <= 10'b0000000000;
            CLK_1 <= 1'b0;
        end else begin
            if (cnt_100 == 10'b1111111111) begin
                cnt_100 <= 10'b0000000000;
                CLK_1 <= ~CLK_1;
            end else begin
                cnt_100 <= cnt_100 + 10'b0000000001;
            end
        end
    end

endmodule
