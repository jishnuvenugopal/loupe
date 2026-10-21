
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


always @(posedge clk or posedge rst) begin
    if (rst) begin
        state <= IDLE;
    end else begin
        case (state)
            IDLE: begin
                if (too_cold && !mode) begin
                    state <= HEATING;
                end else if (too_hot && mode) begin
                    state <= COOLING;
                end else if (fan_on) begin
                    state <= IDLE;
                end
            end
            HEATING: begin
                if (!too_cold) begin
                    state <= IDLE;
                end
            end
            COOLING: begin
                if (!too_hot) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end


always @(posedge clk or posedge rst) begin
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
