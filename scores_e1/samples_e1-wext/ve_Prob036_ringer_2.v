
module TopModule (
    input wire ring,
    input wire vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(ring or vibrate_mode) begin
    if (ring) begin
        ringer <= 1'b1;
        motor <= 1'b0;
    end else if (vibrate_mode) begin
        ringer <= 1'b0;
        motor <= 1'b1;
    end else begin
        ringer <= 1'b0;
        motor <= 1'b0;
    end
end

endmodule
