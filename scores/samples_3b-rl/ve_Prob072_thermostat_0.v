
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    assign heater = (mode) ? too_cold : 1'b0;
    assign fan    = (mode) ? heater : 1'b0;

    
    assign aircon = (!mode) ? too_hot : 1'b0;
    assign fan    = (!mode) ? aircon : 1'b0;

    
    assign fan = fan_on ? 1'b1 : fan;

endmodule
