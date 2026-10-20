
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

    
    reg [1:0] hh_2bit;
    reg [1:0] mm_2bit;
    reg [1:0] ss_2bit;

    
    reg pm_reg;

    
    always @(posedge clk) begin
        if (reset) begin
            hours <= 4'd1;
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
 
                    end else begin
                        hours <= hours + 1;
                        pm_reg <= 1'b1;
 
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    
    assign hh_2bit = hours[3:1];
    assign mm_2bit = minutes[3:1];
    assign ss_2bit = seconds[3:1];

    
    assign hh = {1'b0, hh_2bit};
    assign mm = {1'b0, mm_2bit};
    assign ss = {1'b0, ss_2bit};
    assign pm = pm_reg;

endmodule
