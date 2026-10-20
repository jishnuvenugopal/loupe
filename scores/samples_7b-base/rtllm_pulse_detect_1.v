
module pulse_detect (
    input wire clk,
    input wire rst_n,
    input wire data_in,
    output reg data_out
);

reg [1:0] state;
parameter IDLE = 2'b00,
           DETECT_LOW = 2'b01,
           DETECT_HIGH = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        data_out <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (data_in == 1'b1)
                    state <= DETECT_LOW;
                else
                    state <= IDLE;
                data_out <= 0;
            end
            DETECT_LOW: begin
                if (data_in == 1'b0)
                    state <= DETECT_HIGH;
                else
                    state <= DETECT_LOW;
                data_out <= 0;
            end
            DETECT_HIGH: begin
                if (data_in == 1'b1)
                    state <= DETECT_HIGH;
                else
                    state <= IDLE;
                data_out <= 1;
            end
        endcase
    end
end

endmodule
