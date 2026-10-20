
module TopModule (
    input wire clk,
    input wire reset,
    input wire ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [3:0] hours;
    reg [3:0] minutes;
    reg [3:0] seconds;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm <= 0;
            hours <= 0;
            minutes <= 0;
            seconds <= 0;
        end else begin
            if (ena) begin
                if (seconds == 59) begin
                    seconds <= 0;
                    if (minutes == 59) begin
                        minutes <= 0;
                        if (hours == 11) begin
                            hours <= 0;
                            pm <= 1;
                        end else begin
                            hours <= hours + 1;
                            pm <= 0;
                        end
                    end else begin
                        minutes <= minutes + 1;
                    end
                end else begin
                    seconds <= seconds + 1;
                end
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hh <= 0;
            mm <= 0;
            ss <= 0;
        end else begin
            hh <= hours;
            mm <= minutes;
            ss <= seconds;
        end
    end

endmodule
