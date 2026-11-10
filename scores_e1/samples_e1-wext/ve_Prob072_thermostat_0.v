
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    always @(mode, too_cold, too_hot, fan_on) begin
        if (mode == 1) begin
            
            heater <= 1'b1;
            aircon <= 1'b0;
            fan <= 1'b1;
        end else if (mode == 0) begin
            
            heater <= 1'b0;
            aircon <= 1'b1;
            fan <= 1'b1;
        end else begin
            
            heater <= 1'b0;
            aircon <= 1'b0;
            fan <= 1'b0;
        end

        
        if (heater == 1 || aircon == 1) begin
            fan <= 1'b1;
        end else begin
            fan <= 1'b0;
        end
    end

endmodule
