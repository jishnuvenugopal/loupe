
module radix2_div (
    input clk,
    input rst,
    input sign,
    input [7:0] dividend,
    input [7:0] divisor,
    input opn_valid,
    input res_ready,
    output reg res_valid,
    output [15:0] result
);

    reg [15:0] SR;
 
    reg [7:0] NEG_DIVISOR;
 
    reg [3:0] cnt;
 
    reg start_cnt;
 
    reg res_valid_reg;
    
    reg [7:0] abs_dividend_reg;
    reg [7:0] abs_divisor_reg;
    reg dividend_sign_reg, divisor_sign_reg;
    
    reg opn_in_progress;
    
    
    reg [7:0] quotient;
    reg [7:0] remainder;

    
    wire signed [7:0] signed_dividend = dividend;
    wire signed [7:0] signed_divisor = divisor;
    reg [7:0] signed_abs_dividend;
    reg [7:0] signed_abs_divisor;
    
    
    always @* begin
        if (sign && signed_dividend < 0) begin
            signed_abs_dividend = -signed_dividend;
            dividend_sign_reg = 1;
        end else begin
            signed_abs_dividend = signed_dividend;
            dividend_sign_reg = 0;
        end
        
        if (sign && signed_divisor < 0) begin
            signed_abs_divisor = -signed_divisor;
            divisor_sign_reg = 1;
        end else begin
            signed_abs_divisor = signed_divisor;
            divisor_sign_reg = 0;
        end
    end
    
    
    always @(posedge clk) begin
        if (rst) begin
            res_valid <= 0;
            res_valid_reg <= 0;
            opn_in_progress <= 0;
            SR <= 0;
            NEG_DIVISOR <= 0;
            cnt <= 0;
            start_cnt <= 0;
            quotient <= 0;
            remainder <= 0;
            dividend_sign_reg <= 0;
            divisor_sign_reg <= 0;
        end else begin
            if (res_valid && res_ready)
                res_valid <= 0;
            
            if (opn_valid && !res_valid && !opn_in_progress) begin
                
                abs_dividend_reg <= (sign && dividend[7]) ? (~dividend + 1) : dividend;
                abs_divisor_reg <= (sign && divisor[7]) ? (~divisor + 1) : divisor;
                
                
                SR <= {abs_dividend_reg, 8'b0} << 1;
                NEG_DIVISOR <= -abs_divisor_reg;
                
                cnt <= 1;
                start_cnt <= 1;
                opn_in_progress <= 1;
                res_valid <= 0;
            end
            else if (start_cnt) begin
                if (cnt <= 8) begin
                    
                    if (SR[15:8] >= abs_divisor_reg) begin
                        SR[15:8] <= SR[15:8] - abs_divisor_reg;
                        SR[0] <= 1;
                    end
                    SR <= SR << 1;
                    cnt <= cnt + 1;
                end
                else begin
                    
                    quotient <= SR[7:0];
                    remainder <= SR[15:8];
                    
                    
                    if (dividend_sign_reg ^ divisor_sign_reg)
                        quotient <= ~quotient + 1;
                    if (dividend_sign_reg)
                        remainder <= ~remainder + 1;
                        
                    res_valid <= 1;
                    start_cnt <= 0;
                    opn_in_progress <= 0;
                end
            end
        end
    end
    
    assign result = {remainder, quotient};

endmodule
