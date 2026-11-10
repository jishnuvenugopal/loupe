
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    typedef enum {IDLE, HEATING, COOLING, FAN_ON} state_t;

    
    state_t state = IDLE;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            heater <= 0;
            aircon <= 0;
            fan <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (too_cold) begin
                        state <= HEATING;
                        heater <= 1;
                        aircon <= 0;
                        fan <= 1;
                    end else if (too_hot) begin
                        state <= COOLING;
                        heater <= 0;
                        aircon <= 1;
                        fan <= 1;
                    end else if (fan_on) begin
                        state <= FAN_ON;
                        heater <= 0;
                        aircon <= 0;
                        fan <= 1;
                    end
                end
                HEATING: begin
                    if (too_hot) begin
                        state <= COOLING;
                        heater <= 0;
                        aircon <= 1;
                        fan <= 1;
                    end
                end
                COOLING: begin
                    if (too_cold) begin
                        state <= HEATING;
                        heater <= 1;
                        aircon <= 0;
                        fan <= 1;
                    end
                end
                FAN_ON: begin
                    heater <= 0;
                    aircon <= 0;
                    fan <= 1;
                end
            endcase
        end
    end

endmodule
