
module pulse_detect (
    input clk,
    input rst_n,
    input data_in,
    output reg data_out
);

    
    parameter IDLE = 0;
    parameter PULSE_START = 1;
    parameter PULSE_END = 2;

    reg [2:0] state;

    always @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= IDLE;
            data_out <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (data_in == 1'b0) begin
                        state <= PULSE_START;
                    end else begin
                        state <= IDLE;
                    end
                end
                PULSE_START: begin
                    if (data_in == 1'b1) begin
                        state <= PULSE_END;
                    end else begin
                        state <= IDLE;
                    end
                end
                PULSE_END: begin
                    if (data_in == 1'b0) begin
                        state <= IDLE;
                        data_out <= 1;
                    end else begin
                        state <= PULSE_END;
                        data_out <= 0;
                    end
                end
                default: begin
                    state <= IDLE;
                    data_out <= 0;
                end
            endcase
        end
    end

endmodule
