
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

    
    reg [7:0] SR;
              
    reg [7:0] NEG_DIVISOR;
     
    reg [3:0] cnt;
             
    reg       start_cnt;
       

    
    reg [7:0] quotient;
    reg [7:0] remainder;

    
    reg mux_sel;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR        <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            cnt       <= 4'b0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
            quotient  <= 8'b0;
            remainder <= 8'b0;
            mux_sel   <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                
                SR        <= {1'b0, dividend};
 
                NEG_DIVISOR <= {1'b1, divisor} ^ {8{sign}};
 
                cnt       <= 4'b0;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (res_ready) begin
                
                res_valid <= 1'b0;
                quotient  <= 8'b0;
                remainder <= 8'b0;
                mux_sel   <= 1'b0;
            end else if (start_cnt) begin
                
                if (cnt == 4'd8) begin
                    
                    SR        <= {1'b0, remainder};
 
                    cnt       <= 4'b0;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    
                    SR        <= {SR[6:0], SR[7]};
 
                    cnt       <= cnt + 1'b1;
                    start_cnt <= 1'b0;

                    
                    if (sign) begin
                        
                        if (SR >= NEG_DIVISOR) begin
                            SR <= SR - NEG_DIVISOR;
                            remainder <= remainder + 1'b1;
                        end else begin
                            remainder <= remainder;
                        end
                    end else begin
                        
                        if (SR >= divisor) begin
                            SR <= SR - divisor;
                            remainder <= remainder + 1'b1;
                        end else begin
                            remainder <= remainder;
                        end
                    end
                end
            end else begin
                
                if (sign) begin
                    
                    if (SR >= NEG_DIVISOR) begin
                        mux_sel <= 1'b1;
 
                    end else begin
                        mux_sel <= 1'b0;
                    end
                end else begin
                    
                    if (SR >= divisor) begin
                        mux_sel <= 1'b1;
 
                    end else begin
                        mux_sel <= 1'b0;
                    end
                end
            end
        end
    end

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result <= 16'b0;
        end else begin
            if (res_valid) begin
                result <= {quotient, remainder};
            end else begin
                result <= result;
            end
        end
    end

    
    always @(*) begin
        if (sign) begin
            
            if (mux_sel) begin
                quotient  = quotient + 1'b1;
                remainder = remainder + SR[7];
            end else begin
                quotient  = quotient;
                remainder = remainder + SR[7];
            end
        end else begin
            
            if (mux_sel) begin
                quotient  = quotient + 1'b1;
                remainder = remainder + SR[7];
            end else begin
                quotient  = quotient;
                remainder = remainder + SR[7];
            end
        end
    end

endmodule
