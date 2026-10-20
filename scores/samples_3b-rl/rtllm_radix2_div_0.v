
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

    
    reg [8:0] SR;
             
    reg [7:0] NEG_DIVISOR;
    
    reg       start_cnt;
       
    reg       cnt;
             
    reg       carry_out;
       

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR    <= 9'b0;
            cnt   <= 1'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                
                SR    <= {1'b0, dividend};
 
                cnt   <= 1'b1;
                start_cnt <= 1'b1;
            end else if (start_cnt) begin
                
                if (cnt == 8) begin
                    
                    SR    <= {1'b0, SR[7:0]};
 
                    cnt   <= 1'b0;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    
                    if (sign) begin
                        
                        carry_out <= (SR - {1'b0, divisor})[8];
                    end else begin
                        
                        carry_out <= (SR - {1'b0, divisor})[8];
                    end
                    
                    SR    <= {carry_out, SR[7:1]};
                    cnt   <= cnt + 1'b1;
                end
            end else begin
                res_valid <= 1'b0;
            end
        end
    end

    
    always @(*) begin
        if (res_valid) begin
            result[7:0] = SR[7:0];
 
            result[15:8] = SR[8];
  
        end else begin
            result = 16'b0;
        end
    end

endmodule
