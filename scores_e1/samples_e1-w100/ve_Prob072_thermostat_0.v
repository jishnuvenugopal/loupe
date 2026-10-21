
module TopModule (
    input  wire mode,
    input  wire too_cold,
    input  wire too_hot,
    input  wire fan_on,
    output reg heater,
    output reg aircon,
    output reg fan
);

    
    enum { HEATING, COOLING, IDLE } state;

    
    reg [1:0] heater_state;
    reg [1:0] aircon_state;
    reg [1:0] fan_state;

    
    always @(posedge clk or negedge rst) begin
        if (rst) begin
            state <= IDLE;
            heater_state <= 2'b00;
            aircon_state <= 2'b00;
            fan_state <= 2'b00;
        end else begin
            case (state)
                IDLE: begin
                    if (mode == 1) begin
                        state <= HEATING;
                        heater_state <= 2'b01;
                        aircon_state <= 2'b00;
                        fan_state <= 2'b01;
                    end else if (mode == 0) begin
                        state <= COOLING;
                        heater_state <= 2'b00;
                        aircon_state <= 2'b01;
                        fan_state <= 2'b01;
                    end
                end
                HEATING: begin
                    if (too_cold == 1) begin
                        heater_state <= 2'b01;
                        aircon_state <= 2'b00;
                        fan_state <= 2'b01;
                    end else if (too_hot == 1) begin
                        heater_state <= 2'b00;
                        aircon_state <= 2'b00;
                        fan_state <= 2'b00;
                    end else if (fan_on == 1) begin
                        heater_state <= 2'b01;
                        aircon_state <= 2'b00;
                        fan_state <= 2'b01;
                    end
                end
                COOLING: begin
                    if (too_cold == 1) begin
                        heater_state <= 2'b00;
                        aircon_state <= 2'b01;
                        fan_state <= 2'b01;
                    end else if (too_hot == 1) begin
                        heater_state <= 2'b00;
                        aircon_state <= 2'b00;
                        fan_state <= 2'b00;
                    end else if (fan_on == 1) begin
                        heater_state <= 2'b00;
                        aircon_state <= 2'b01;
                        fan_state <= 2'b01;
                    end
                end
            endcase
        end
    end

    
    assign heater = heater_state[1];
    assign aircon = aircon_state[1];
    assign fan = fan_state[1];

endmodule
