
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    reg [3:0] hours;
    reg [3:0] minutes;
    reg [3:0] seconds;

    
    wire [1:0] hh_bcd;
    wire [1:0] mm_bcd;
    wire [1:0] ss_bcd;

    
    reg pm_reg;

    
    assign hh_bcd = (hours > 9) ? 2'b10 : 2'b00 + hours[3:1];
    assign mm_bcd = (minutes > 9) ? 2'b10 : 2'b00 + minutes[3:1];
    assign ss_bcd = (seconds > 9) ? 2'b10 : 2'b00 + seconds[3:1];

    always @(posedge clk) begin
        if (reset) begin
            hours <= 4'd12;
            minutes <= 4'd0;
            seconds <= 4'd0;
            pm_reg <= 1'b0;
        end else if (ena) begin
            if (seconds == 4'd59) begin
                seconds <= 4'd0;
                if (minutes == 4'd59) begin
                    minutes <= 4'd0;
                    if (hours == 4'd12) begin
                        hours <= 4'd1;
                        pm_reg <= 1'b0;
                    end else if (hours == 4'd13) begin
                        hours <= 4'd1;
                        pm_reg <= 1'b1;
                    end else begin
                        hours <= hours + 1;
                        pm_reg <= 1'b0;
                    end
                end else begin
                    minutes <= minutes + 1;
                    pm_reg <= 1'b0;
                end
            end else begin
                seconds <= seconds + 1;
                pm_reg <= 1'b0;
            end
        end
    end

    assign pm = pm_reg;
    assign hh = hh_bcd;
    assign mm = mm_bcd;
    assign ss = ss_bcd;

endmodule
