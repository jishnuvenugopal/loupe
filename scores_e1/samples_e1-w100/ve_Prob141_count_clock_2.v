
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

    
    reg pm_flag;

    
    reg reset_flag;

    
    assign hours = hours_reg;
    assign minutes = minutes_reg;
    assign seconds = seconds_reg;
    assign pm = pm_flag;
    assign hh = hours_reg;
    assign mm = minutes_reg;
    assign ss = seconds_reg;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_flag <= 1'b1;
            hours_reg <= 4'b0000;
            minutes_reg <= 4'b0000;
            seconds_reg <= 4'b0000;
            pm_flag <= 1'b0;
        end else if (ena) begin
            if (hours_reg == 4'b1111) begin
                hours_reg <= 4'b0000;
                minutes_reg <= minutes_reg + 1'b1;
                if (minutes_reg == 4'b59) begin
                    minutes_reg <= 4'b0000;
                    seconds_reg <= seconds_reg + 1'b1;
                    if (seconds_reg == 4'b59) begin
                        seconds_reg <= 4'b0000;
                        pm_flag <= ~pm_flag;
                    end
                end
            end else begin
                hours_reg <= hours_reg + 1'b1;
                minutes_reg <= minutes_reg + 1'b0;
                seconds_reg <= seconds_reg + 1'b0;
            end
        end
    end

endmodule
