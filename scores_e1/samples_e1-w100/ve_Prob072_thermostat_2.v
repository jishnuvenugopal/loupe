
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);


typedef enum {HEATING, COOLING, IDLE} state_t;


state_t state = IDLE;


always @(posedge clk or negedge rst) begin
    if (rst) begin
        state <= IDLE;
        heater <= 0;
        aircon <= 0;
        fan <= 0;
    end else begin
        case (state)
            IDLE: begin
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
                    state <= IDLE;
                    heater <= 0;
                    aircon <= 0;
                    fan <= 0;
                end
            end
            HEATING: begin
                if (too_hot == 1) begin
                    state <= IDLE;
                    heater <= 0;
                    aircon <= 0;
                    fan <= 0;
                end else begin
                    state <= HEATING;
                end
            end
            COOLING: begin
                if (too_cold == 1) begin
                    state <= IDLE;
                    heater <= 0;
                    aircon <= 0;
                    fan <= 0;
                end else begin
                    state <= COOLING;
                end
            end
        endcase
    end
end


always @(posedge clk or negedge rst) begin
    if (rst) begin
        heater <= 0;
        aircon <= 0;
        fan <= 0;
    end else begin
        case (state)
            IDLE: begin
                heater <= 0;
                aircon <= 0;
                fan <= 0;
            end
            HEATING: begin
                heater <= 1;
                aircon <= 0;
                fan <= 1;
            end
            COOLING: begin
                heater <= 0;
                aircon <= 1;
                fan <= 1;
            end
        endcase
    end
end

endmodule
