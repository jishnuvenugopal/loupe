
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss 
);
    reg [3:0] ss_ones;
    reg [3:0] ss_tens;
    reg [3:0] mm_ones;
    reg [3:0] mm_tens;
    reg [3:0] hh_tens;
    reg [3:0] hh_ones;
    reg pm_reg;

    wire ss_max = (ss_tens == 4'd5) && (ss_ones == 4'd9);
    wire mm_max = (mm_tens == 4'd5) && (mm_ones == 4'd9);
    wire increment_hour = ena && ss_max && mm_max;

    assign ss = {ss_tens, ss_ones};
    assign mm = {mm_tens, mm_ones};
    assign hh = {hh_tens, hh_ones};
    assign pm = pm_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            ss_ones <= 4'd0;
            ss_tens <= 4'd0;
        end else if (ena) begin
            if (ss_ones == 4'd9) begin
                ss_ones <= 4'd0;
                if (ss_tens == 4'd5)
                    ss_tens <= 4'd0;
                else
                    ss_tens <= ss_tens + 4'd1;
            end else begin
                ss_ones <= ss_ones + 4'd1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            mm_ones <= 4'd0;
            mm_tens <= 4'd0;
        end else if (increment_hour) begin
            if (mm_ones == 4'd9) begin
                mm_ones <= 4'd0;
                if (mm_tens == 4'd5)
                    mm_tens <= 4'd0;
                else
                    mm_tens <= mm_tens + 4'd1;
            end else begin
                mm_ones <= mm_ones + 4'd1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            hh_tens <= 4'd1;
            hh_ones <= 4'd2;
            pm_reg <= 1'b0;
        end else if (increment_hour) begin
            if ((hh_tens == 4'd1) && (hh_ones == 4'd2)) begin
                
                hh_tens <= 4'd0;
                hh_ones <= 4'd1;
                pm_reg <= ~pm_reg;
            end else begin
                if (hh_ones == 4'd9) begin
                    hh_ones <= 4'd0;
                    hh_tens <= hh_tens + 4'd1;
                    
                    if (hh_tens > 4'd1) begin
                        hh_tens <= 4'd0;
                        hh_ones <= 4'd1;
 
                    end
                end else begin
                    hh_ones <= hh_ones + 4'd1;
                end
            end
        end
    end
endmodule
