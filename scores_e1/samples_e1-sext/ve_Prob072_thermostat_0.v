
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    typedef enum {HEATING, COOLING, STANDBY} state_t;
    state_t state = STANDBY;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STANDBY;
            heater <= 0;
            aircon <= 0;
            fan <= 0;
        end else begin
            case (state)
                STANDBY: begin
                    if (mode == 1 && too_cold == 1) begin
                        state <= HEATING;
                        heater <= 1;
                        aircon <= 0;
                        fan <= 1;
                    end else if (mode == 0 && too_hot == 1) begin
                        state <= COOLING;
                        heater <= 0;
                        aircon <= 1;
                        fan <= 1;
                    end else begin
                        state <= STANDBY;
                        heater <= 0;
                        aircon <= 0;
                        fan <= 0;
                    end
                end
                HEATING: begin
                    state <= HEATING;
                    heater <= 1;
                    aircon <= 0;
                    fan <= 1;
                end
                COOLING: begin
                    state <= COOLING;
                    heater <= 0;
                    aircon <= 1;
                    fan <= 1;
                end
            endcase
        end
    end

endmodule
