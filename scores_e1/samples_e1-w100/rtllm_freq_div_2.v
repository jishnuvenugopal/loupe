
module freq_div (
    input wire CLK_in,
    input wire RST,
    output reg CLK_50,
    output reg CLK_10,
    output reg CLK_1
);

reg [1:0] cnt_50, cnt_10, cnt_100;
reg [1:0] state;

always @(posedge CLK_in or posedge RST) begin
    if (RST) begin
        cnt_50 <= 2'b00;
        cnt_10 <= 2'b00;
        cnt_100 <= 2'b00;
        state <= 2'b00;
        CLK_50 <= 0;
        CLK_10 <= 0;
        CLK_1 <= 0;
    end else begin
        case (state)
            2'b00: begin
                if (cnt_50 == 2'b11) begin
                    cnt_50 <= 2'b00;
                    state <= 2'b01;
                end else begin
                    cnt_50 <= cnt_50 + 1'b1;
                end
            end
            2'b01: begin
                if (cnt_10 == 2'b11) begin
                    cnt_10 <= 2'b00;
                    state <= 2'b10;
                end else begin
                    cnt_10 <= cnt_10 + 1'b1;
                end
            end
            2'b10: begin
                if (cnt_100 == 2'b11) begin
                    cnt_100 <= 2'b00;
                    state <= 2'b00;
                end else begin
                    cnt_100 <= cnt_100 + 1'b1;
                end
            end
            default: state <= 2'b00;
        endcase

        if (state == 2'b00) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else if (state == 2'b01) begin
            CLK_50 <= 1;
            CLK_10 <= 0;
            CLK_1 <= 0;
        end else if (state == 2'b10) begin
            CLK_50 <= 0;
            CLK_10 <= 1;
            CLK_1 <= 0;
        end else if (state == 2'b11) begin
            CLK_50 <= 0;
            CLK_10 <= 0;
            CLK_1 <= 1;
        end
    end
end

endmodule
