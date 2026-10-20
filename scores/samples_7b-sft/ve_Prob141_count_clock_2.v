
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);
    reg [3:0] ss_tens, ss_units;
    reg [3:0] mm_tens, mm_units;
    reg [3:0] internal_hour;
    reg pm_reg;
    wire mm_rollover = (mm_tens == 4'd5) && (mm_units == 4'd9) && ena;
    wire ss_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

    
    always @(posedge clk) begin
        if (reset) begin
            ss_tens <= 4'd0;
            ss_units <= 4'd0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_units <= ss_units + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            mm_tens <= 4'd0;
            mm_units <= 4'd0;
        end else if (ena && ss_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end else begin
                mm_units <= mm_units + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            internal_hour <= 4'd0;
            pm_reg <= 1'b0;
        end else if (ena && mm_rollover) begin
            if (internal_hour == 4'd11) begin
                internal_hour <= 4'd0;
                pm_reg <= ~pm_reg;
            end else begin
                internal_hour <= internal_hour + 1;
            end
        end
    end

    
    assign ss = {ss_tens, ss_units};
    assign mm = {mm_tens, mm_units};
    assign hh = (internal_hour == 4'd0) ? 8'h12 : {4'd0, internal_hour};
    assign pm = pm_reg;

endmodule
