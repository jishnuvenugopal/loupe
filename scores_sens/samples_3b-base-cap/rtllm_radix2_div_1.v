
module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    input wire res_ready,
    output reg [15:0] result,
    output reg res_valid
);

    
    localparam WIDTH = 8;
    localparam HALF_WIDTH = WIDTH / 2;
    localparam MAX_COUNTER = 2**HALF_WIDTH - 1;

    
    reg [WIDTH-1:0] dividend_abs;
    reg [WIDTH-1:0] divisor_abs;
    reg [WIDTH-1:0] neg_divisor;
    reg [WIDTH-1:0] shift_register;
    reg [HALF_WIDTH-1:0] cnt;
    reg [HALF_WIDTH-1:0] start_cnt;
    reg [WIDTH-1:0] remainder;
    reg [WIDTH-1:0] quotient;
    reg [WIDTH-1:0] subtract_result;
    reg [WIDTH-1:0] carry_out;
    reg [WIDTH-1:0] result_upper;
    reg [WIDTH-1:0] result_lower;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            dividend_abs <= 0;
            divisor_abs <= 0;
            neg_divisor <= 0;
            shift_register <= 0;
            cnt <= 0;
            start_cnt <= 0;
            remainder <= 0;
            quotient <= 0;
            subtract_result <= 0;
            carry_out <= 0;
            result_upper <= 0;
            result_lower <= 0;
            res_valid <= 0;
        end else begin
            if (opn_valid && !res_valid) begin
                dividend_abs <= (sign ? ~dividend + 1 : dividend);
                divisor_abs <= (sign ? ~divisor + 1 : divisor);
                neg_divisor <= ~divisor_abs + 1;
                shift_register <= dividend_abs << 1;
                cnt <= 0;
                start_cnt <= 1;
            end else if (start_cnt) begin
                if (cnt == MAX_COUNTER) begin
                    cnt <= 0;
                    start_cnt <= 0;
                    result_upper <= remainder;
                    result_lower <= quotient;
                    res_valid <= 1;
                end else begin
                    cnt <= cnt + 1;
                    subtract_result <= shift_register - neg_divisor;
                    carry_out <= subtract_result[WIDTH-1];
                    shift_register <= (subtract_result << 1) | carry_out;
                end
            end
        end
    end

    
    assign result = {result_upper, result_lower};

endmodule
