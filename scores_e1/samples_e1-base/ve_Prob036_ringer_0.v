
module TopModule (
    input ring,
    input vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        ringer <= 0;
        motor <= 0;
    end else begin
        if (ring && !vibrate_mode) begin
            ringer <= 1;
            motor <= 0;
        end else if (vibrate_mode) begin
            ringer <= 0;
            motor <= 1;
        end else begin
            ringer <= 0;
            motor <= 0;
        end
    end
end

endmodule
