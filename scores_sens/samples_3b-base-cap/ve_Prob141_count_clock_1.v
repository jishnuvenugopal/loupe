
module TopModule (
    input  clk,
    input  reset,
    input  ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [3:0] hour_counter;
    reg [3:0] minute_counter;
    reg [3:0] second_counter;

    
    reg [3:0] hour_bcd;
    reg [3:0] minute_bcd;
    reg [3:0] second_bcd;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            pm <= 1'b0;
 
        end else if (ena) begin
            if (hour_counter >= 12) begin
                pm <= 1'b1;
 
            end else begin
                pm <= 1'b0;
 
            end
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour_counter <= 4'b0000;
        end else if (ena) begin
            hour_counter <= hour_counter + 1'b1;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            minute_counter <= 4'b0000;
        end else if (ena) begin
            minute_counter <= minute_counter + 1'b1;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            second_counter <= 4'b0000;
        end else if (ena) begin
            second_counter <= second_counter + 1'b1;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            hour_bcd <= 4'b0000;
        end else if (ena) begin
            hour_bcd <= hour_counter;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            minute_bcd <= 4'b0000;
        end else if (ena) begin
            minute_bcd <= minute_counter;
        end
    end

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            second_bcd <= 4'b0000;
        end else if (ena) begin
            second_bcd <= second_counter;
        end
    end

    
    assign hh = hour_bcd;
    assign mm = minute_bcd;
    assign ss = second_bcd;

endmodule
