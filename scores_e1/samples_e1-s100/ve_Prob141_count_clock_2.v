
module TopModule (
    input clk,
    input reset,
    input ena,
    output pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    
    reg [3:0] hour_counter;
    reg [5:0] minute_counter;
    reg [5:0] second_counter;

    
    reg pm_indicator;

    
    reg reset_signal;

    
    reg enable_signal;

    
    reg clock_signal;

    
    reg clock_edge;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour_counter <= 4'b0000;
            minute_counter <= 6'b00000;
            second_counter <= 6'b00000;
            pm_indicator <= 1'b0;
            reset_signal <= 1'b1;
        end else if (ena) begin
            if (clock_edge) begin
                if (second_counter == 6'b11111) begin
                    second_counter <= 6'b00000;
                    if (minute_counter == 6'b59) begin
                        minute_counter <= 6'b00000;
                        if (hour_counter == 4'b1111) begin
                            hour_counter <= 4'b0000;
                            pm_indicator <= ~pm_indicator;
                        end else begin
                            hour_counter <= hour_counter + 1'b1;
                        end
                    end else begin
                        minute_counter <= minute_counter + 1'b1;
                    end
                end else begin
                    second_counter <= second_counter + 1'b1;
                end
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_signal <= 1'b1;
        end else if (ena) begin
            reset_signal <= 1'b0;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm_indicator <= 1'b0;
        end else if (ena) begin
            pm_indicator <= ~pm_indicator;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hh <= 8'b00000000;
            mm <= 8'b00000000;
            ss <= 8'b00000000;
        end else if (ena) begin
            hh <= hour_counter;
            mm <= minute_counter;
            ss <= second_counter;
        end
    end

endmodule
