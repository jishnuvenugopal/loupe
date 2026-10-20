
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    assign heater = (mode == 1'b1) ? too_cold : 1'b0;
    assign aircon = (mode == 1'b1) ? 1'b0 : too_hot;
    assign fan    = (heater == 1'b1 || fan_on == 1'b1) ? 1'b1 : 1'b0;

    
    
    
    assign heater = (mode == 1'b0) ? 1'b0 : too_cold;
    assign aircon = (mode == 1'b0) ? too_hot : 1'b0;
    assign fan    = (aircon == 1'b1 || fan_on == 1'b1) ? 1'b1 : 1'b0;

endmodule
