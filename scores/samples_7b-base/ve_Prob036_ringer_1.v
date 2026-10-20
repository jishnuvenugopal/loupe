
module TopModule(
    input wire ring,
    input wire vibrate_mode,
    output reg ringer,
    output reg motor
);

    always @(*) begin
        ringer = 0;
        motor = 0;
        
        if (vibrate_mode) begin
            motor = 1;
        end else if (ring) begin
            ringer = 1;
        end
    end

endmodule
