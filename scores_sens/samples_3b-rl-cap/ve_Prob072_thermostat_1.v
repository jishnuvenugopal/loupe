
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    wire heater_temp;
    wire aircon_temp;

    
    assign heater_temp = (mode) ? too_cold : 1'b0;

    
    assign aircon_temp = (!mode) ? too_hot : 1'b0;

    
    assign fan = fan_on | heater_temp | aircon_temp;

    
    assign heater = heater_temp;

    
    assign aircon = aircon_temp;

endmodule
