
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    
    
    
    assign heater = (mode == 1) && too_cold;
    assign aircon = 0;
    assign fan    = heater || fan_on;

    
    
    
    
    assign heater = 0;
    assign aircon = (mode == 0) && too_hot;
    assign fan    = aircon || fan_on;

endmodule
