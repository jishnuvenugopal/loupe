
module radix2_div (
    input        clk,
    input        rst,
    input        sign,         
    input  [7:0] dividend,
    input  [7:0] divisor,
    input        opn_valid,
    input        res_ready,
    output reg   res_valid,
    output reg [15:0] result
);

    
    reg [8:0] SR;
         
    reg [7:0] NEG_DIVISOR;
 
    reg       start_cnt;
  
    reg [3:0] cnt;
        

    
    reg [15:0] result_reg;
    reg res_valid_reg;

    
    wire [8:0] sub_result;
    wire [7:0] sub_result_quotient;
    wire [7:0] sub_result_remainder;
    wire       sub_result_carry;

    
    wire [8:0] mux_result;
    assign mux_result = sub_result_carry ? sub_result_remainder : sub_result_quotient;

    
    wire [7:0] abs_dividend;
    wire [7:0] abs_divisor;

    
    assign abs_dividend = (dividend[7] ? ~dividend + 1'b1 : dividend);

    
    assign abs_divisor = (divisor[7] ? ~divisor + 1'b1 : divisor);

    
    assign NEG_DIVISOR = sign ? ~abs_divisor + 1'b1 : abs_divisor;

    
    assign sub_result = SR - NEG_DIVISOR;
    assign sub_result_quotient = sub_result[7:0];
    assign sub_result_remainder = sub_result[8];
    assign sub_result_carry = sub_result[9];

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR      <= 9'b0;
            cnt     <= 4'b0;
            start_cnt <= 1'b0;
            res_valid_reg <= 1'b0;
            result_reg <= 16'b0;
        end else begin
            if (opn_valid && !res_valid_reg) begin
                SR      <= {1'b0, abs_dividend};
                cnt     <= 4'b0;
                start_cnt <= 1'b1;
                res_valid_reg <= 1'b0;
                result_reg <= 16'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    SR      <= {sub_result_remainder, sub_result_quotient};
                    cnt     <= 4'b0;
                    start_cnt <= 1'b0;
                    res_valid_reg <= 1'b1;
                    result_reg <= {sub_result_quotient, sub_result_remainder};
                end else begin
                    SR      <= {1'b0, SR[8:1]};
                    cnt     <= cnt + 1'b1;
                end
            end
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (res_valid_reg && res_ready) begin
                res_valid <= 1'b0;
                result <= 16'b0;
            end else if (res_valid_reg) begin
                res_valid <= 1'b1;
                result <= result_reg;
            end
        end
    end

endmodule
