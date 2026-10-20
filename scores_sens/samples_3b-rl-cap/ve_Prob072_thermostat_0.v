
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    assign heater = mode ? too_cold : 1'b0;
    assign aircon = mode ? 1'b0 : too_hot;
    assign fan    = mode ? fan_on : heater;

    
    assign heater = mode ? 1'b0 : too_cold;
    assign aircon = mode ? too_hot : 1'b0;
    assign fan    = mode ? fan_on : aircon;

endmodule
