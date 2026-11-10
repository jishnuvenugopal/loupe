
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    enum reg [1:0] {IDLE, HEATING, COOLING} state;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            heater <= 0;
            aircon <= 0;
            fan <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (too_cold && !aircon && !fan_on) begin
                        state <= HEATING;
                        heater <= 1;
                        aircon <= 0;
                        fan <= 1;
                    end else if (too_hot && !heater && !fan_on) begin
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
                    if (!too_cold && !aircon && !fan_on) begin
                        state <= IDLE;
                        heater <= 0;
                        aircon <= 0;
                        fan <= 0;
                    end else begin
                        state <= HEATING;
                        heater <= 1;
                        aircon <= 0;
                        fan <= 1;
                    end
                end
                COOLING: begin
                    if (!too_hot && !heater && !fan_on) begin
                        state <= IDLE;
                        heater <= 0;
                        aircon <= 0;
                        fan <= 0;
                    end else begin
                        state <= COOLING;
                        heater <= 0;
                        aircon <= 1;
                        fan <= 1;
                    end
                end
            endcase
        end
    end

endmodule
