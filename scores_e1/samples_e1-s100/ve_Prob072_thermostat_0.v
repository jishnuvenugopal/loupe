
module TopModule (
    input wire mode,
    input wire too_cold,
    input wire too_hot,
    input wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    typedef enum {IDLE, HEATING, COOLING} State;
    State state = IDLE;

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
                    end else if (too_hot) begin
                        state <= COOLING;
                    end
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

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            fan <= 0;
        end else begin
            if (heater || aircon) begin
                fan <= 1;
            end else begin
                fan <= 0;
            end
        end
    end

endmodule
