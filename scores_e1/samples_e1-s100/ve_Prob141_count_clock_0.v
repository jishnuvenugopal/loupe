
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    reg clk;
    reg reset;
    reg ena;

    
    reg pm;

    
    reg [3:0] hours;
    reg [5:0] minutes;
    reg [5:0] seconds;

    
    initial begin
        hours = 4'b0000;
 
        minutes = 6'b0000;
        seconds = 6'b0000;
        pm = 1'b0;
 
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours = 4'b0000;
            minutes = 6'b0000;
            seconds = 6'b0000;
            pm = 1'b0;
        end else if (ena) begin
            if (seconds == 6'b1111) begin
                seconds = 6'b0000;
                if (minutes == 6'b59) begin
                    minutes = 6'b0000;
                    if (hours == 11'b1111) begin
                        hours = 4'b0000;
                        pm = ~pm;
                    end else begin
                        hours = hours + 1'b1;
                    end
                end else begin
                    minutes = minutes + 1'b1;
                end
            end else begin
                seconds = seconds + 1'b1;
            end
        end
    end

    
    always @(*) begin
        if (hours == 4'b0000 || hours == 4'b0010 || hours == 4'b0100 || hours == 4'b0110 || hours == 4'b1000 || hours == 4'b1010 || hours == 4'b1100) begin
            pm = 1'b0;
 
        end else begin
            pm = 1'b1;
 
        end
    end

    
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;
    assign pm = pm;

endmodule
