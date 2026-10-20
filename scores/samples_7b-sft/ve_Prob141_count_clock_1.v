
module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output [7:0] hh,
    output [7:0] mm,
    output [7:0] ss
);

    reg [3:0] ss_tens;
 
    reg [3:0] ss_units;
 
    reg [3:0] mm_tens;
    reg [3:0] mm_units;
    reg [3:0] hour;

    wire minute_rollover = (ss_tens == 4'd5) && (ss_units == 4'd9) && ena;

    
    always @(posedge clk) begin
        if (reset) begin
            ss_tens <= 4'd0;
            ss_units <= 4'd0;
        end else if (ena) begin
            if (ss_units == 4'd9) begin
                ss_units <= 4'd0;
                ss_tens <= (ss_tens == 4'd5) ? 4'd0 : ss_tens + 1;
            end else begin
                ss_units <= ss_units + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            mm_tens <= 4'd0;
            mm_units <= 4'd0;
        end else if (minute_rollover) begin
            if (mm_units == 4'd9) begin
                mm_units <= 4'd0;
                mm_tens <= (mm_tens == 4'd5) ? 4'd0 : mm_tens + 1;
            end else begin
                mm_units <= mm_units + 1;
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            hour <= 4'd12;
            pm <= 1'b0;
        end else if (minute_rollover) begin
            if (hour == 4'd12) begin
                hour <= 4'd1;
                pm <= ~pm;
            end else if (hour == 4'd11) begin
                hour <= 4'd12;
                pm <= ~pm;
            end else begin
                hour <= hour + 1;
            end
        end
    end

    
    wire [3:0] hh_tens = (hour >= 4'd10) ? 4'd1 : 4'd0;
    wire [3:0] hh_units = (hour >= 4'd10) ? (hour - 4'd10) : hour;
    assign hh = {hh_tens, hh_units};

    
    assign mm = {mm_tens, mm_units};
    assign ss = {ss_tens, ss_units};

endmodule
