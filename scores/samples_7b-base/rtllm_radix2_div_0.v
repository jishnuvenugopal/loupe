
module radix2_div (
    input wire clk,
    input wire rst,
    input wire sign,
    input wire [7:0] dividend,
    input wire [7:0] divisor,
    input wire opn_valid,
    input wire res_ready,
    output reg res_valid,
    output reg [15:0] result
);

    reg [7:0] sr;
       
    reg [7:0] neg_divisor;
  
    reg [3:0] cnt;
      
    reg [3:0] start_cnt;
  
    reg [7:0] temp;
     

    
    function [7:0] neg_abs;
        input [7:0] val;
        reg [7:0] result;
        if (val[7])
            result = ~val + 1;
        else
            result = val;
        return result;
    endfunction

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt <= 4'b0000;
            start_cnt <= 4'b0000;
            res_valid <= 1'b0;
            sr <= 8'b00000000;
            neg_divisor <= 8'b00000000;
            result <= 16'b0000000000000000;
        end else begin
            if (opn_valid && !res_valid) begin
                sr <= {dividend, 1'b0};
  
                neg_divisor <= {neg_abs(divisor), 1'b0};
                cnt <= 4'b0001;
                start_cnt <= 4'b0001;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'b1000) begin
                    cnt <= 4'b0000;
                    start_cnt <= 4'b0000;
                    result[7:0] <= sr[7:0];
  
                    result[15:8] <= sr[15:8];
 
                    res_valid <= 1'b1;
                end else begin
                    cnt <= cnt + 1;
                    temp <= sr - neg_divisor;
  
                    if (temp[8]) begin  
                        sr <= {temp[7:0], 1'b1};
  
                        result[7:0] <= result[7:0] - 1;
  
                    end else begin
                        sr <= {temp[7:0], 1'b0};
  
                    end
                end
            end
            if (res_ready) begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule
