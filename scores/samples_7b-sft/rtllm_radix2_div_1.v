
module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    input res_ready,
    output reg res_valid,
    output reg [15:0] result
);

    reg [1:0] state;
    reg [2:0] cnt;
    reg [15:0] SR;
    reg [7:0] abs_dividend;
    reg [7:0] abs_divisor;
    reg [7:0] quotient;
    reg [7:0] remainder;
    reg sign_quotient;
    reg sign_remainder;
    reg [7:0] stored_dividend;
    reg [7:0] stored_divisor;
    reg start_cnt;

    localparam IDLE = 2'b00;
    localparam PROCESSING = 2'b01;
    localparam DONE = 2'b10;

    always @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            res_valid <= 0;
            result <= 16'b0;
            SR <= 16'b0;
            cnt <= 0;
            start_cnt <= 0;
            stored_dividend <= 8'b0;
            stored_divisor <= 8'b0;
            abs_dividend <= 8'b0;
            abs_divisor <= 8'b0;
            sign_quotient <= 0;
            sign_remainder <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (opn_valid && !res_valid) begin
                        stored_dividend <= dividend;
                        stored_divisor <= divisor;
                        if (sign) begin
                            abs_dividend <= dividend[7] ? (-dividend) : dividend;
                            abs_divisor <= divisor[7] ? (-divisor) : divisor;
                            sign_quotient <= (dividend[7] ^ divisor[7]);
                            sign_remainder <= dividend[7];
                        end else begin
                            abs_dividend <= dividend;
                            abs_divisor <= divisor;
                            sign_quotient <= 0;
                            sign_remainder <= 0;
                        end
                        SR <= {7'b0, abs_dividend, 1'b0};
                        cnt <= 0;
                        start_cnt <= 1;
                        state <= PROCESSING;
                    end
                end
                PROCESSING: begin
                    if (start_cnt) begin
                        if (cnt < 8) begin
                            wire [8:0] temp_sub = {1'b0, SR[15:8]} - {1'b0, abs_divisor};
                            if (temp_sub[8] == 0) begin
                                SR[15:8] <= temp_sub[7:0];
                                SR[0] <= 1'b1;
                            end else begin
                                SR[0] <= 1'b0;
                            end
                            SR <= SR << 1;
                            cnt <= cnt + 1;
                        end else begin
                            remainder <= (sign && sign_remainder) ? -SR[15:8] : SR[15:8];
                            quotient <= (sign && sign_quotient) ? -SR[7:0] : SR[7:0];
                            result <= {remainder, quotient};
                            res_valid <= 1;
                            state <= DONE;
                        end
                    end
                end
                DONE: begin
                    if (res_ready) begin
                        res_valid <= 0;
                        state <= IDLE;
                    end
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule
