
module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [3:0] seconds_counter;
    reg [3:0] minutes_counter;
    reg [3:0] hours_counter;
    reg am_pm;

    
    always @(posedge clk) begin
        if (reset) begin
            
            seconds_counter <= 4'd0;
            minutes_counter <= 4'd0;
            hours_counter <= 4'd0;
            am_pm <= 0;
 
        end else if (ena) begin
            
            if (seconds_counter == 4'd59) begin
                seconds_counter <= 4'd0;
                
                if (minutes_counter == 4'd59) begin
                    minutes_counter <= 4'd0;
                    
                    if (hours_counter == 4'd11) begin
                        hours_counter <= 4'd0;
                        
                        am_pm <= ~am_pm;
                    end else begin
                        hours_counter <= hours_counter + 1;
                    end
                end else begin
                    minutes_counter <= minutes_counter + 1;
                end
            end else begin
                seconds_counter <= seconds_counter + 1;
            end
        end
    end

    
    assign pm = am_pm;
    assign hh[7:4] = hours_counter[3:0];
    assign hh[3:0] = hours_counter[3:0];
    assign mm[7:4] = minutes_counter[3:0];
    assign mm[3:0] = minutes_counter[3:0];
    assign ss[7:4] = seconds_counter[3:0];
    assign ss[3:0] = seconds_counter[3:0];

endmodule
