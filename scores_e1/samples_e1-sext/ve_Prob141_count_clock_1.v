
module TopModule (
    input clk,
    input reset,
    input ena,
    output reg pm,
    output reg [7:0] hh,
    output reg [7:0] mm,
    output reg [7:0] ss
);

reg [3:0] hour_counter;
reg [5:0] minute_counter;
reg [5:0] second_counter;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        hour_counter <= 4'b0000;
        minute_counter <= 6'b00000;
        second_counter <= 6'b00000;
        pm <= 1'b0;
    end else if (ena) begin
        hour_counter <= hour_counter + 1'b1;
        if (hour_counter == 4'b1000) begin
            hour_counter <= 4'b0000;
            minute_counter <= minute_counter + 1'b1;
            if (minute_counter == 6'b100000) begin
                minute_counter <= 6'b00000;
                second_counter <= second_counter + 1'b1;
                if (second_counter == 6'b100000) begin
                    second_counter <= 6'b00000;
                    if (hour_counter == 4'b12) begin
                        hour_counter <= 4'b0000;
                        pm <= ~pm;
                    end
                end
            end
        end
    end
end

assign hh = hour_counter[3:0];
assign mm = minute_counter[5:0];
assign ss = second_counter[5:0];
assign pm = hour_counter[3];

endmodule
