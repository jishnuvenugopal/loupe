
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

always @(mode, too_cold, too_hot, fan_on) begin
    if (mode == 1) begin
        if (too_cold) begin
            heater <= 1;
            aircon <= 0;
            fan <= 1;
        end else begin
            heater <= 0;
            aircon <= 0;
            fan <= 0;
        end
    end else begin
        if (too_hot) begin
            heater <= 0;
            aircon <= 1;
            fan <= 1;
        end else begin
            heater <= 0;
            aircon <= 0;
            fan <= 0;
        end
    end
end

endmodule
