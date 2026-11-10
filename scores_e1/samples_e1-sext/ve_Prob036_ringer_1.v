
module TopModule (
    input wire ring,
    input wire vibrate_mode,
    output reg ringer,
    output reg motor
);

always @(*) begin
    if (ring == 1) begin
        ringer = 1;
        motor = 0;
    end else if (vibrate_mode == 1) begin
        motor = 1;
    end else begin
        ringer = 1;
        motor = 0;
    end
end

endmodule
