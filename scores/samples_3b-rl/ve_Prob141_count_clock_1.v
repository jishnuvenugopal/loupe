
module TopModule (
    input  wire clk,
    input  wire reset,
    input  wire ena,
    output reg  pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

    
    reg [7:0] hours;
    reg [7:0] minutes;
    reg [7:0] seconds;

    always @(posedge clk) begin
        if (reset) begin
            hours   <= 8'd0;
            minutes <= 8'd0;
            seconds <= 8'd0;
            pm      <= 1'b0;
        end else if (ena) begin
            if (seconds == 8'd59) begin
                seconds <= 8'd0;
                if (minutes == 8'd59) begin
                    minutes <= 8'd0;
                    if (hours == 8'd12) begin
                        hours   <= 8'd1;
                        pm      <= 1'b1;
                    end else begin
                        hours   <= hours + 1'b1;
                        pm      <= 1'b0;
                    end
                end else begin
                    minutes <= minutes + 1'b1;
                end
            end else begin
                seconds <= seconds + 1'b1;
            end
        end
    end

    
    always @(*) begin
        hh = (hours == 8'd12) ? 8'd0 : hours;
        mm = minutes;
        ss = seconds;
    end

endmodule
