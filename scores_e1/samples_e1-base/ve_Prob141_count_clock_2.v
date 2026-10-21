
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
    reg [5:0] minutes;
    reg [5:0] seconds;

    
    reg [1:0] am_pm;

    
    reg [3:0] bcd_hours;
    reg [3:0] bcd_minutes;
    reg [3:0] bcd_seconds;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 4'b0000;
            minutes <= 6'b00000;
            seconds <= 6'b00000;
            am_pm <= 2'b00;
            bcd_hours <= 4'b0000;
            bcd_minutes <= 4'b0000;
            bcd_seconds <= 4'b0000;
        end else if (ena) begin
            hours <= hours + 1'b1;
            if (hours == 4'b1000) begin
                hours <= 4'b0000;
                minutes <= minutes + 1'b1;
                if (minutes == 6'b10000) begin
                    minutes <= 6'b00000;
                    seconds <= seconds + 1'b1;
                    if (seconds == 6'b10000) begin
                        seconds <= 6'b00000;
                        am_pm <= am_pm ^ 2'b01;
                        if (am_pm == 2'b01) begin
                            bcd_hours <= 4'b0001;
                            bcd_minutes <= 4'b0000;
                            bcd_seconds <= 4'b0000;
                        end else begin
                            bcd_hours <= 4'b0010;
                            bcd_minutes <= 4'b0000;
                            bcd_seconds <= 4'b0000;
                        end
                    end
                end
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            bcd_hours <= 4'b0000;
            bcd_minutes <= 4'b0000;
            bcd_seconds <= 4'b0000;
        end else if (ena) begin
            bcd_hours <= hours;
            bcd_minutes <= minutes;
            bcd_seconds <= seconds;
        end
    end

    
    assign hh = bcd_hours;
    assign mm = bcd_minutes;
    assign ss = bcd_seconds;

    
    assign pm = am_pm == 2'b01;

endmodule
