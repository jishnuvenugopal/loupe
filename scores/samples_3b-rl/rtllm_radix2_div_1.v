
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
     
    reg [7:0] DIVIDEND;
        
    reg [7:0] DIVISOR;
         
    reg       start_cnt;
       
    reg [7:0] cnt;
             
    reg [7:0] QUOTIENT;
        
    reg [7:0] REMAINDER;
       

    
    wire [7:0] mux_result;

    
    assign mux_result = (SR[8] == 1'b0) ? SR : {8'b0, dividend};

    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            SR      <= 8'b0;
            NEG_DIVISOR <= 8'b0;
            DIVIDEND <= 8'b0;
            DIVISOR  <= 8'b0;
            start_cnt <= 1'b0;
            cnt       <= 8'b0;
            QUOTIENT  <= 8'b0;
            REMAINDER <= 8'b0;
            res_valid <= 1'b0;
        end else begin
            if (opn_valid && !res_valid) begin
                
                SR      <= {1'b0, dividend};
 
                NEG_DIVISOR <= ~divisor + 1'b1;
 
                DIVIDEND <= (sign) ? dividend : dividend;
                DIVISOR  <= (sign) ? ~divisor + 1'b1 : divisor;
                start_cnt <= 1'b1;
                cnt       <= 8'b0;
                QUOTIENT  <= 8'b0;
                REMAINDER <= 8'b0;
            end else if (start_cnt) begin
                if (cnt == 8) begin
                    
                    SR      <= {1'b0, REMAINDER};
 
                    QUOTIENT <= cnt;
                    start_cnt <= 1'b0;
                    res_valid <= 1'b1;
                end else begin
                    
                    if (SR < NEG_DIVISOR) begin
                        
                        SR <= {1'b1, SR};
 
                    end else begin
                        SR <= {1'b0, SR};
 
                    end
                    cnt <= cnt + 1'b1;
                end
            end else begin
                
                res_valid <= res_ready;
            end
        end
    end

    
    always @(*) begin
        if (res_valid) begin
            result = {REMAINDER, QUOTIENT};
        end else begin
            result = 16'b0;
        end
    end

endmodule
