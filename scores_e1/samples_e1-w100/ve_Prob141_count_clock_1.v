
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

    
    reg pm_indicator;

    
    reg [1:0] clock_state;
    reg [1:0] clock_next_state;

    
    reg [1:0] reset_state;
    reg [1:0] reset_next_state;

    
    reg [1:0] pm_indicator_state;
    reg [1:0] pm_indicator_next_state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clock_state <= 2'b00;
            reset_state <= 2'b00;
            pm_indicator_state <= 2'b00;
        end else begin
            clock_state <= clock_next_state;
            reset_state <= reset_next_state;
            pm_indicator_state <= pm_indicator_next_state;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hours <= 4'b0000;
            minutes <= 6'b00000;
            seconds <= 6'b00000;
            pm_indicator <= 1'b0;
        end else begin
            case (clock_state)
                2'b00: begin
                    if (ena) begin
                        hours <= hours + 1'b1;
                        if (hours == 4'b1000) hours <= 4'b0000;
                        minutes <= minutes + 1'b1;
                        if (minutes == 6'b100000) minutes <= 6'b00000;
                        seconds <= seconds + 1'b1;
                        if (seconds == 6'b100000) seconds <= 6'b00000;
                        if (hours == 4'b1000 && minutes == 6'b100000 && seconds == 6'b100000) pm_indicator <= 1'b1;
                    end
                end
                2'b01: begin
                    if (ena) begin
                        hours <= hours + 1'b1;
                        if (hours == 4'b1000) hours <= 4'b0000;
                        minutes <= minutes + 1'b1;
                        if (minutes == 6'b100000) minutes <= 6'b00000;
                        seconds <= seconds + 1'b1;
                        if (seconds == 6'b100000) seconds <= 6'b00000;
                        if (hours == 4'b1000 && minutes == 6'b100000 && seconds == 6'b100000) pm_indicator <= 1'b1;
                    end
                end
                2'b10: begin
                    if (ena) begin
                        hours <= hours + 1'b1;
                        if (hours == 4'b1000) hours <= 4'b0000;
                        minutes <= minutes + 1'b1;
                        if (minutes == 6'b100000) minutes <= 6'b00000;
                        seconds <= seconds + 1'b1;
                        if (seconds == 6'b100000) seconds <= 6'b00000;
                        if (hours == 4'b1000 && minutes == 6'b100000 && seconds == 6'b100000) pm_indicator <= 1'b1;
                    end
                end
                2'b11: begin
                    if (ena) begin
                        hours <= hours + 1'b1;
                        if (hours == 4'b1000) hours <= 4'b0000;
                        minutes <= minutes + 1'b1;
                        if (minutes == 6'b100000) minutes <= 6'b00000;
                        seconds <= seconds + 1'b1;
                        if (seconds == 6'b100000) seconds <= 6'b00000;
                        if (hours == 4'b1000 && minutes == 6'b100000 && seconds == 6'b100000) pm_indicator <= 1'b1;
                    end
                end
            endcase
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clock_next_state <= 2'b00;
        end else begin
            clock_next_state <= 2'b01;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            reset_next_state <= 2'b00;
        end else begin
            reset_next_state <= 2'b01;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm_indicator_next_state <= 2'b00;
        end else begin
            pm_indicator_next_state <= 2'b01;
        end
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm_indicator <= 1'b0;
        end else begin
            pm_indicator <= pm_indicator_next_state;
        end
    end

endmodule
