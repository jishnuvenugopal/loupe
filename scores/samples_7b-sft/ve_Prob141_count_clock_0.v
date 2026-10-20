
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] tens_h, units_h;
  
    reg [3:0] tens_mm, units_mm;
 
    reg [3:0] tens_ss, units_ss;
 
    reg pm_reg;
                 

    
    wire ss_rollover, mm_rollover;

    assign hh = {tens_h, units_h};
    assign mm = {tens_mm, units_mm};
    assign ss = {tens_ss, units_ss};
    assign pm = pm_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            tens_ss <= 4'd0;
            units_ss <= 4'd0;
        end else if (ena) begin
            if (units_ss == 4'd9) begin
                units_ss <= 4'd0;
                if (tens_ss == 4'd5) begin
                    tens_ss <= 4'd0;
                    ss_rollover <= 1;
                end else begin
                    tens_ss <= tens_ss + 1;
                end
            end else begin
                units_ss <= units_ss + 1;
            end
        end else begin
            ss_rollover <= 0;
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            tens_mm <= 4'd0;
            units_mm <= 4'd0;
            mm_rollover <= 0;
        end else begin
            mm_rollover <= 0;
            if (ss_rollover) begin
                if (units_mm == 4'd9) begin
                    units_mm <= 4'd0;
                    if (tens_mm == 4'd5) begin
                        tens_mm <= 4'd0;
                        mm_rollover <= 1;
                    end else begin
                        tens_mm <= tens_mm + 1;
                    end
                end else begin
                    units_mm <= units_mm + 1;
                end
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            tens_h <= 4'd1;
            units_h <= 4'd2;
            pm_reg <= 0;
        end else if (ena && mm_rollover) begin
            if (tens_h == 4'd1 && units_h == 4'd1) begin  
                tens_h <= 4'd1;
                units_h <= 4'd2;
                pm_reg <= ~pm_reg;
            end else if (tens_h == 4'd1 && units_h == 4'd2) begin  
                tens_h <= 4'd0;
                units_h <= 4'd1;
            end else begin
                if (units_h == 4'd9) begin
                    units_h <= 4'd0;
                    tens_h <= tens_h + 1;
                end else begin
                    units_h <= units_h + 1;
                end
            end
        end
    end

endmodule
