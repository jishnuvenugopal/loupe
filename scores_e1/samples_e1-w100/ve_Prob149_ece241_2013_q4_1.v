
module TopModule (
    input clk,
    input reset,
    input [2:0] s,
    output reg fr2,
    output reg fr1,
    output reg fr0,
    output reg dfr
);

    
    reg [2:0] current_level;
    reg [2:0] previous_level;
    reg [2:0] sensor_assertions;
    reg [2:0] flow_rates;
    reg [2:0] supplemental_flow_valve;

    
    enum reg [1:0] {Initial, Level1, Level2, Level3, Level4} state;

    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_level <= 3'b000;
            previous_level <= 3'b000;
            sensor_assertions <= 3'b000;
            flow_rates <= 3'b000;
            supplemental_flow_valve <= 3'b000;
            state <= Initial;
        end else begin
            case (state)
                Initial: begin
                    if (s[2]) begin
                        current_level <= 3'b001;
                        previous_level <= 3'b000;
                        sensor_assertions <= 3'b001;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level1;
                    end else begin
                        current_level <= 3'b000;
                        previous_level <= 3'b000;
                        sensor_assertions <= 3'b000;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Initial;
                    end
                end
                Level1: begin
                    if (s[1]) begin
                        current_level <= 3'b010;
                        previous_level <= 3'b010;
                        sensor_assertions <= 3'b010;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level2;
                    end else begin
                        current_level <= 3'b010;
                        previous_level <= 3'b010;
                        sensor_assertions <= 3'b010;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level1;
                    end
                end
                Level2: begin
                    if (s[0]) begin
                        current_level <= 3'b100;
                        previous_level <= 3'b100;
                        sensor_assertions <= 3'b100;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level3;
                    end else begin
                        current_level <= 3'b100;
                        previous_level <= 3'b100;
                        sensor_assertions <= 3'b100;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level2;
                    end
                end
                Level3: begin
                    if (s[0]) begin
                        current_level <= 3'b101;
                        previous_level <= 3'b101;
                        sensor_assertions <= 3'b101;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level4;
                    end else begin
                        current_level <= 3'b101;
                        previous_level <= 3'b101;
                        sensor_assertions <= 3'b101;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level3;
                    end
                end
                Level4: begin
                    if (s[0]) begin
                        current_level <= 3'b000;
                        previous_level <= 3'b000;
                        sensor_assertions <= 3'b000;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level1;
                    end else begin
                        current_level <= 3'b000;
                        previous_level <= 3'b000;
                        sensor_assertions <= 3'b000;
                        flow_rates <= 3'b000;
                        supplemental_flow_valve <= 3'b000;
                        state <= Level4;
                    end
                end
            endcase

            
            if (sensor_assertions == 3'b001) begin
                flow_rates <= 3'b000;
            end else if (sensor_assertions == 3'b010) begin
                flow_rates <= 3'b000;
            end else if (sensor_assertions == 3'b100) begin
                flow_rates <= 3'b000;
            end else if (sensor_assertions == 3'b101) begin
                flow_rates <= 3'b000;
            end

            
            if (previous_level < current_level) begin
                supplemental_flow_valve <= 3'b001;
            end else begin
                supplemental_flow_valve <= 3'b000;
            end

            
            previous_level <= current_level;
        end
    end

    
    assign fr2 = flow_rates[2];
    assign fr1 = flow_rates[1];
    assign fr0 = flow_rates[0];
    assign dfr = supplemental_flow_valve;

endmodule
