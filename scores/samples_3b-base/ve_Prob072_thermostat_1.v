
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output wire heater,
    output wire aircon,
    output wire fan
);

    
    always @(posedge mode or posedge too_cold or posedge too_hot or posedge fan_on) begin
        
        heater = (mode == 1) && too_cold;

        
        aircon = (mode == 0) && too_hot;

        
        fan = fan_on || heater || aircon;
    end

endmodule
