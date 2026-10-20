
module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    input res_ready,
    output reg res_valid = 0,
    output [15:0] result
);

    reg [7:0] quotient, remainder;
    reg [7:0] dividend_abs, divisor_abs;
    reg [3:0] cnt;
    reg processing;
    reg [16:0] sr;
    
    
    always @* begin
        if (sign) begin
            dividend_abs = dividend[7] ? -dividend : dividend;
            divisor_abs = divisor[7] ? -divisor : divisor;
        end
        else begin
            dividend_abs = dividend;
            divisor_abs = divisor;
        end
    end

    assign result = {remainder, quotient};

    always @(posedge clk) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            processing <= 0;
            cnt <= 0;
            res_valid <= 0;
            sr <= 0;
        end else begin
            if (res_ready && res_valid) begin
                res_valid <= 0;
            end

            if (!processing && opn_valid && !res_valid) begin
                
                sr <= {dividend_abs, 1'b0};
                quotient <= 0;
                remainder <= 0;
                cnt <= 0;
                processing <= 1;
            end

            if (processing) begin
                if (cnt < 8) begin
                    
                    if (sr[16:9] >= divisor_abs) begin
                        remainder <= sr[16:9] - divisor_abs;
                        quotient <= {quotient[6:0], 1'b1};
                    end else begin
                        quotient <= {quotient[6:0], 1'b0};
                    end
                    sr <= {sr[15:0], 1'b0};
                    cnt <= cnt + 1;
                end
                else begin
                    
                    processing <= 0;
                    res_valid <= 1;
                end
            end
        end
    end
endmodule
