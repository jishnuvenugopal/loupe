
module TopModule(
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] ss_10s;
    reg [3:0] ss_0s;
    reg [3:0] mm_10s;
    reg [3:0] mm_0s;
    reg [3:0] hh_tens;
    reg [3:0] hh_ones;
    reg pm_reg;

    assign hh = {hh_tens, hh_ones};
    assign mm = {mm_10s, mm_0s};
    assign ss = {ss_10s, ss_0s};
    assign pm = pm_reg;

    always @(posedge clk) begin
        if (reset) begin
            ss_10s <= 4'd0;
            ss_0s <= 4'd0;
            mm_10s <= 4'd0;
            mm_0s <= 4'd0;
            hh_tens <= 4'd1;
            hh_ones <= 4'd2;
            pm_reg <= 1'b0;
        end else if (ena) begin
            if (ss_0s == 4'd9) begin
                ss_0s <= 4'd0;
                if (ss_10s == 4'd5) begin
                    ss_10s <= 4'd0;
                    if (mm_0s == 4'd9) begin
                        mm_0s <= 4'd0;
                        if (mm_10s == 4'd5) begin
                            mm_10s <= 4'd0;
                            if (hh_ones == 4'd2 && hh_tens == 4'd1) begin
                                hh_tens <= 4'd0;
                                hh_ones <= 4'd1;
                            end else begin
                                if (hh_ones == 4'd9) begin
                                    hh_ones <= 4'd0;
                                    hh_tens <= hh_tens + 4'd1;
                                end else begin
                                    hh_ones <= hh_ones + 4'd1;
                                end
                                if ((hh_tens == 4'd1) && (hh_ones == 4'd1)) begin
                                    pm_reg <= ~pm_reg;
                                end
                            end
                        end else begin
                            mm_10s <= mm_10s + 4'd1;
                        end
                    end else begin
                        mm_0s <= mm_0s + 4'd1;
                    end
                end else begin
                    ss_10s <= ss_10s + 4'd1;
                end
            end else begin
                ss_0s <= ss_0s + 4'd1;
            end
        end
    end
endmodule
