
module TopModule (
    input wire clk,
    input wire reset,
    input wire ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [3:0] hour_counter;
    reg [3:0] hour_counter_next;

    
    reg [5:0] minute_counter;
    reg [5:0] minute_counter_next;

    
    reg [5:0] second_counter;
    reg [5:0] second_counter_next;

    
    reg pm_indicator;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour_counter <= 4'b0000;
            minute_counter <= 6'b00000;
            second_counter <= 6'b00000;
            pm_indicator <= 1'b0;
        end else if (ena) begin
            hour_counter_next <= hour_counter + 1'b1;
            minute_counter_next <= minute_counter + 1'b1;
            second_counter_next <= second_counter + 1'b1;

            
            if (hour_counter == 4'b1000) begin
                pm_indicator <= ~pm_indicator;
            end
        end
    end

    
    assign pm = pm_indicator;
    assign hh = hour_counter;
    assign mm = minute_counter;
    assign ss = second_counter;

endmodule
