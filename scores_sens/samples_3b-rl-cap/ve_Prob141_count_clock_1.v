
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire ena,
    output reg  pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [3:0] hours;
    reg [3:0] minutes;
    reg [3:0] seconds;

    
    reg [3:0] am_pm;

    
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;

    always @(posedge clk) begin
        if (reset) begin
            
            hours   <= 4'd0;
            minutes <= 4'd0;
            seconds <= 4'd0;
            am_pm   <= 4'd0;
            pm      <= 1'b0;
        end else if (ena) begin
            
            if (seconds == 4'd59) begin
                seconds <= 4'd0;
                
                if (minutes == 4'd59) begin
                    minutes <= 4'd0;
                    
                    if (hours == 4'd12) begin
                        hours   <= 4'd1;
                        minutes <= 4'd0;
                        seconds <= 4'd0;
                        
                        am_pm <= am_pm + 1'b1;
                        pm <= ~pm;
                    end else begin
                        hours <= hours + 1'b1;
                    end
                end else begin
                    minutes <= minutes + 1'b1;
                end
            end else begin
                seconds <= seconds + 1'b1;
            end
        end
    end

endmodule
