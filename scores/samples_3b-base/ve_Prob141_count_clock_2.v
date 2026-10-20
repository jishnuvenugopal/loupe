
module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    localparam HOURS_12 = 12;
    localparam MINUTES_59 = 59;
    localparam SECONDS_59 = 59;

    
    reg [3:0] hours;
    reg [3:0] minutes;
    reg [3:0] seconds;
    reg pm_flag;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
            pm_flag <= 0;
        end else if (ena) begin
            if (seconds == SECONDS_59) begin
                seconds <= 0;
                if (minutes == MINUTES_59) begin
                    minutes <= 0;
                    if (hours == HOURS_12) begin
                        hours <= 0;
                        pm_flag <= ~pm_flag;
                    end else begin
                        hours <= hours + 1;
                    end
                end else begin
                    minutes <= minutes + 1;
                end
            end else begin
                seconds <= seconds + 1;
            end
        end
    end

    
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;
    assign pm = pm_flag;

endmodule
