
module TopModule (
    input wire ring,
    input wire vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(ring, vibrate_mode) begin
    if (vibrate_mode) begin
        motor <= 1;
        ringer <= 0;
    end else begin
        if (ring) begin
            ringer <= 1;
            motor <= 0;
        end else begin
            ringer <= 0;
            motor <= 0;
        end
    end
end

endmodule
