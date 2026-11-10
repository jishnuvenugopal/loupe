
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    reg [3:0] hours = 0;
    reg [3:0] minutes = 0;
    reg [3:0] seconds = 0;
    reg [3:0] hour_counter = 0;
    reg [3:0] ampm_counter = 0;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
            hour_counter <= 0;
            ampm_counter <= 0;
        end else if (ena) begin
            hour_counter <= hour_counter + 1;
            if (hour_counter == 12) begin
                hour_counter <= 0;
                ampm_counter <= ampm_counter + 1;
            end
            if (ampm_counter == 2) begin
                ampm_counter <= 0;
            end
            seconds <= seconds + 1;
            if (seconds == 60) begin
                seconds <= 0;
                minutes <= minutes + 1;
                if (minutes == 60) begin
                    minutes <= 0;
                    hours <= hours + 1;
                end
            end
        end
    end

    
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;

    
    assign pm = (ampm_counter == 1);

endmodule
