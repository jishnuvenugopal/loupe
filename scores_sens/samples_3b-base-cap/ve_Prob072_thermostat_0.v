
module TopModule (
    input  wire mode,          
    input  wire too_cold,      
    input  wire too_hot,       
    input  wire fan_on,        
    output wire heater,        
    output wire aircon,        
    output wire fan            
);

    
    wire heater_control;
    wire aircon_control;

    
    always @(posedge mode or posedge too_cold) begin
        if (mode) begin
            heater_control = too_cold;
        end else begin
            heater_control = 0;
        end
    end

    
    always @(posedge mode or posedge too_hot) begin
        if (!mode) begin
            aircon_control = too_hot;
        end else begin
            aircon_control = 0;
        end
    end

    
    always @(posedge fan_on or posedge heater_control or posedge aircon_control) begin
        fan = fan_on || heater_control || aircon_control;
    end

    
    assign heater = heater_control;
    assign aircon = aircon_control;

endmodule
