
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(mode, too_cold, too_hot, fan_on) begin
    if (mode == 1) begin
        heater <= 1;
        aircon <= 0;
        fan <= fan_on;
    end else if (mode == 0) begin
        heater <= 0;
        aircon <= 1;
        fan <= fan_on;
    end else begin
        heater <= 0;
        aircon <= 0;
        fan <= 0;
    end
end

endmodule
