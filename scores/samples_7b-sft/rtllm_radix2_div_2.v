
module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    output reg res_valid,
    output reg [15:0] result
);

reg [7:0] abs_dividend, abs_divisor;
reg [7:0] quotient, remainder;
reg [15:0] SR;
reg [3:0] cnt;
reg [1:0] state;
reg dividend_sign, divisor_sign;

localparam IDLE = 2'b00;
localparam RUN = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk) begin
    if (rst) begin
        state <= IDLE;
        res_valid <= 0;
        result <= 0;
        SR <= 0;
        cnt <= 0;
        abs_dividend <= 0;
        abs_divisor <= 0;
        dividend_sign <= 0;
        divisor_sign <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (opn_valid && !res_valid) begin
                    dividend_sign <= sign ? dividend[7] : 1'b0;
                    divisor_sign <= sign ? divisor[7] : 1'b0;
                    abs_dividend <= sign ? (dividend[7] ? -dividend : dividend) : dividend;
                    abs_divisor <= sign ? (divisor[7] ? -divisor : divisor) : divisor;
                    SR <= {abs_dividend, 8'b0} << 1;
                    cnt <= 1;
                    state <= RUN;
                end
            end
            RUN: begin
                if (cnt == 8) begin
                    remainder <= SR[15:8];
                    quotient <= SR[7:0];
                    if (sign) begin
                        if (dividend_sign) remainder <= -remainder;
                        if (dividend_sign ^ divisor_sign) quotient <= -quotient;
                    end
                    res_valid <= 1;
                    state <= DONE;
                end else begin
                    wire [8:0] sub_result = {1'b0, SR[15:8]} - {1'b0, abs_divisor};
                    wire borrow = sub_result[8];
                    wire [7:0] new_remainder = sub_result[7:0];
                    SR <= {SR[14:0], 1'b0};
                    if (borrow) begin
                        SR[15:8] <= SR[15:8];
                        SR[0] <= 0;
                    end else begin
                        SR[15:8] <= new_remainder;
                        SR[0] <= 1;
                    end
                    cnt <= cnt + 1;
                end
            end
            DONE: begin
                if (res_ready) begin
                    result <= {remainder, quotient};
                    res_valid <= 0;
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule
