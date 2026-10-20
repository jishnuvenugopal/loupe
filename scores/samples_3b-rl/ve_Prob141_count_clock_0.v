
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

    always @(posedge clk) begin
        if (reset) begin
            
            hours   <= 4'd12;
            minutes <= 4'd0;
            seconds <= 4'd0;
            pm      <= 1'b0;
        end else begin
            if (ena) begin
                
                if (seconds == 4'd59) begin
                    seconds <= 4'd0;
                    if (minutes == 4'd59) begin
                        minutes <= 4'd0;
                        if (hours == 4'd11) begin
                            hours   <= 4'd1;
                            pm      <= ~pm;
                        end else begin
                            hours   <= hours + 4'd1;
                            pm      <= 1'b1;
                        end
                    end else begin
                        minutes <= minutes + 4'd1;
                    end
                end else begin
                    seconds <= seconds + 4'd1;
                end
            end
        end
    end

    
    assign hh = hours;
    assign mm = minutes;
    assign ss = seconds;
    assign pm = pm;

endmodule
