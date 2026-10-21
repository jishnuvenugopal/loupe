
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    reg [3:0] hour_counter = 4'b0000;
    reg [5:0] minute_counter = 6'b00000;
    reg [5:0] second_counter = 6'b00000;

    
    reg pm_indicator = 1'b0;

    
    always @(posedge clk) begin
        if (ena) begin
            if (hour_counter == 4'b1111) begin
                hour_counter = 4'b0000;
                minute_counter = 6'b00000;
                second_counter = 6'b00000;
            end else begin
                hour_counter <= hour_counter + 1'b1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (ena) begin
            if (hour_counter == 4'b1111) begin
                pm_indicator <= ~pm_indicator;
            end
        end
    end

    
    assign hh = hour_counter;
    assign mm = minute_counter;
    assign ss = second_counter;
    assign pm = pm_indicator;

endmodule
