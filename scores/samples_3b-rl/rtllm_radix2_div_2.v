
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
     
    reg [3:0] cnt;
             
    reg       start_cnt;
       

    
    reg [8:0] temp_result;

    
    reg mux_sel;

    
    reg [15:0] result_reg;

    
    reg result_reg_valid;

    
    reg result_reg_ready;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            result_reg <= 16'd0;
            result_reg_valid <= 1'b0;
            result_reg_ready <= 1'b0;
        end else begin
            if (res_ready) begin
                result_reg <= 16'd0;
                result_reg_valid <= 1'b0;
                result_reg_ready <= 1'b0;
            end else if (res_valid) begin
                result_reg <= result;
                result_reg_valid <= 1'b1;
                result_reg_ready <= 1'b0;
            end
        end
    end

    
    assign res_valid = result_reg_valid;
    assign result = result_reg;

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR <= 9'd0;
            NEG_DIVISOR <= 8'd0;
            cnt <= 4'd0;
            start_cnt <= 1'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                
                SR <= {1'b0, dividend};
 
                if (sign) begin
                    NEG_DIVISOR <= ~divisor + 8'd1;
 
                end else begin
                    NEG_DIVISOR <= ~divisor;
 
                end
                cnt <= 4'd1;
                start_cnt <= 1'b1;
                res_valid <= 1'b0;
            end else if (start_cnt) begin
                if (cnt == 4'd8) begin
                    
                    res_valid <= 1'b1;
                    start_cnt <= 1'b0;
                    cnt <= 4'd0;
                    
                    result <= {SR[0], SR[8:1]};
                end else begin
                    
                    if (sign) begin
                        
                        temp_result = SR - NEG_DIVISOR;
                    end else begin
                        
                        temp_result = SR - NEG_DIVISOR;
                    end
                    
                    mux_sel = temp_result[8];
                    
                    SR <= {mux_sel, SR[8:1]} << 1;
                    cnt <= cnt + 4'd1;
                end
            end else begin
                res_valid <= 1'b0;
            end
        end
    end

endmodule
