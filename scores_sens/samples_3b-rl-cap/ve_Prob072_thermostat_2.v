
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output reg  heater,
    output reg  aircon,
    output reg  fan
);

always @(*) begin
    if (mode == 1'b1) begin 
        heater = too_cold;
        aircon = 1'b0;
        fan = heater | fan_on;
    end else begin 
        heater = 1'b0;
        aircon = too_hot;
        fan = aircon | fan_on;
    end
end

endmodule
