
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);


parameter IDLE = 2'b00,
          RISING = 2'b01,
          FALLING = 2'b10,
          PULSE_END = 2'b11;


reg [1:0] state;


reg [1:0] next_state;
reg pulse_detected;


always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        state <= next_state;
        data_out <= (state == PULSE_END);
    end
end


always @(*) begin
    next_state = state;
    pulse_detected = 0;

    case (state)
        IDLE: begin
            if (data_in == 1) begin
                next_state = RISING;
            end
        end
        RISING: begin
            if (data_in == 0) begin
                next_state = FALLING;
            end
        end
        FALLING: begin
            if (data_in == 1) begin
                next_state = RISING;
            end else begin
                next_state = PULSE_END;
            end
        end
        PULSE_END: begin
            next_state = IDLE;
        end
    endcase
end

endmodule
