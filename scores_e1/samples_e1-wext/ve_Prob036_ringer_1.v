
module TopModule (
    input wire ring,
    input wire vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(ring or vibrate_mode) begin
        if (ring && vibrate_mode) begin
            ringer <= 1;
            motor <= 1;
        end else if (ring) begin
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

endmodule
