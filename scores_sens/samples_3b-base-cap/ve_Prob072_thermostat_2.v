
module TopModule (
    input  logic mode,
    input  logic too_cold,
    input  logic too_hot,
    input  logic fan_on,
    output logic heater,
    output logic aircon,
    output logic fan
);

    
    logic is_heating;
    assign is_heating = mode & too_cold;

    
    logic is_cooling;
    assign is_cooling = mode & too_hot;

    
    logic heater_state;
    assign heater_state = is_heating | fan_on;

    
    logic aircon_state;
    assign aircon_state = is_cooling | fan_on;

    
    logic fan_state;
    assign fan_state = fan_on;

    
    assign heater = heater_state;
    assign aircon = aircon_state;
    assign fan = fan_state;

endmodule
