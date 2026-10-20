
module radix2_div (
    input        clk,
    input        rst,
    input        sign,         
    input  [7:0] dividend,
    input  [7:0] divisor,
    input        opn_valid,    
    input        res_ready,    
    output reg       res_valid,
    output reg [15:0] result
);

    
    reg [15:0] SR;
         
    reg        start_cnt;
  
    reg        cnt;
        
    reg [7:0]  NEG_DIVISOR;
 

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            res_valid <= 1'b0;
            result <= 16'b0;
        end else begin
            if (opn_valid && !res_ready) begin
                res_valid <= 1'b0;
                result <= 16'b0;
            end else if (start_cnt && cnt == 8'd8) begin
                res_valid <= 1'b1;
                result <= {SR[7:0], SR[15:8]};
                start_cnt <= 1'b0;
                cnt <= 1'b0;
            end else begin
                res_valid <= 1'b0;
                result <= 16'b0;
            end
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 16'b0;
            start_cnt <= 1'b0;
            cnt <= 1'b0;
        end else begin
            if (opn_valid && !res_ready) begin
                SR <= 16'b0;
                start_cnt <= 1'b1;
                cnt <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 8'd8) begin
                    
                    start_cnt <= 1'b0;
                    cnt <= 1'b0;
                end else begin
                    
                    if (sign) begin
                        
                        if (SR[15:8] >= NEG_DIVISOR) begin
                            SR <= {SR[14:0], SR[15:8] - NEG_DIVISOR};
                        end else begin
                            SR <= {SR[14:0], SR[15:8] + 8'd256 - NEG_DIVISOR};
                        end
                    end else begin
                        
                        if (SR[15:8] >= divisor) begin
                            SR <= {SR[14:0], SR[15:8] - divisor};
                        end else begin
                            SR <= {SR[14:0], SR[15:8] + 8'd256 - divisor};
                        end
                    end
                    cnt <= cnt + 1'b1;
                end
            end
        end
    end

    
    always @(*) begin
        if (sign)
            NEG_DIVISOR = ~divisor + 8'd1;
        else
            NEG_DIVISOR = divisor;
    end

endmodule
