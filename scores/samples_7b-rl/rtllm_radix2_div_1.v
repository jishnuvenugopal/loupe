
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

    
    reg [7:0] abs_dividend, abs_divisor;
    reg [7:0] NEG_DIVISOR;
    reg sign_quotient, sign_remainder;
    reg [15:0] SR;
 
    reg [3:0] cnt;
    reg start_cnt;
    reg processing;
    reg [7:0] saved_dividend, saved_divisor;
    reg saved_sign;

    
    reg [8:0] temp_sum;

    
    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            start_cnt <= 0;
            processing <= 0;
            cnt <= 0;
            SR <= 0;
            result <= 0;
            saved_dividend <= 0;
            saved_divisor <= 0;
            saved_sign <= 0;
            sign_quotient <= 0;
            sign_remainder <= 0;
            NEG_DIVISOR <= 0;
        end else begin
            if (res_ready && res_valid) begin
                res_valid <= 0;
            end

            if (opn_valid && !res_valid && !processing) begin
                
                saved_sign <= sign;
                saved_dividend <= dividend;
                saved_divisor <= divisor;

                
                if (sign) begin
                    abs_dividend = dividend[7] ? (~dividend + 1) : dividend;
                    abs_divisor = divisor[7] ? (~divisor + 1) : divisor;
                end else begin
                    abs_dividend = dividend;
                    abs_divisor = divisor;
                end

                
                NEG_DIVISOR <= -abs_divisor;

                sign_quotient <= (sign && (dividend[7] ^ divisor[7]));
                sign_remainder <= (sign && dividend[7]);

                
                SR <= {abs_dividend, 8'h00} << 1;

                
                cnt <= 1;
                start_cnt <= 1;
                processing <= 1;
            end else if (start_cnt && processing) begin
                if (cnt <= 8) begin
                    if (cnt < 8) begin
                        
                        temp_sum = {1'b0, SR[15:8]} + NEG_DIVISOR;

                        if (temp_sum[8]) begin
                            
                            SR <= {temp_sum[7:0], SR[7:0]} << 1 | 8'h01;
                        end else begin
                            
                            SR <= {SR[15:8], SR[7:0]} << 1;
                        end

                        cnt <= cnt + 1;
                    end else begin
                        
                        reg [7:0] final_quotient, final_remainder;

                        if (saved_sign) begin
                            final_quotient = sign_quotient ? (~SR[7:0] + 1) : SR[7:0];
                            final_remainder = sign_remainder ? (~SR[15:8] + 1) : SR[15:8];
                        end else begin
                            final_quotient = SR[7:0];
                            final_remainder = SR[15:8];
                        end

                        result <= {final_remainder, final_quotient};
                        res_valid <= 1;
                        start_cnt <= 0;
                        processing <= 0;
                    end
                end
            end
        end
    end

endmodule
