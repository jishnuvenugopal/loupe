
module TopModule (
    input clk,
    input reset,
    input in,
    output done
);

    reg [1:0] state;
    reg [2:0] bit_count;
    reg [7:0] rx_data;
    reg done_reg;

    localparam S_IDLE = 2'b00;
    localparam S_RECEIVE = 2'b01;
    localparam S_CHECK_STOP = 2'b10;
    localparam S_WAIT_STOP = 2'b11;

    always @(posedge clk) begin
        if (reset) begin
            state <= S_IDLE;
            done_reg <= 0;
            bit_count <= 0;
            rx_data <= 0;
        end else begin
            case (state)
                S_IDLE: begin
                    done_reg <= 0;
                    if (in == 0) begin
                        state <= S_RECEIVE;
                        bit_count <= 0;
                        rx_data <= 0;
                    end
                end
                S_RECEIVE: begin
                    rx_data <= (rx_data << 1) | in;
                    if (bit_count == 3'd7) begin
                        state <= S_CHECK_STOP;
                    end else begin
                        bit_count <= bit_count + 1;
                    end
                end
                S_CHECK_STOP: begin
                    if (in) begin
                        done_reg <= 1;
                        state <= S_IDLE;
                    end else begin
                        state <= S_WAIT_STOP;
                    end
                end
                S_WAIT_STOP: begin
                    if (in) begin
                        state <= S_IDLE;
                    end
                end
                default: state <= S_IDLE;
            endcase
        end
    end

    assign done = done_reg;

endmodule
