
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
        
        if (mode == 1) begin 
            heater = too_cold;
 
            aircon = 0;
 
            fan = fan_on || heater;
 
        end else if (mode == 0) begin 
            heater = 0;
 
            aircon = too_hot;
 
            fan = fan_on || aircon;
 
        end else begin 
            heater = 0;
 
            aircon = 0;
 
            fan = 0;
 
        end
    end

endmodule
