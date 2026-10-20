
module fixed_point_adder #(
    parameter Q = 4, 
    parameter N = 8  
) (
    input [N-1:0] a, 
    input [N-1:0] b, 
    output reg [N-1:0] c  
);

    
    reg [N-1:0] res;
 

    
    function [N-1:0] sign;
        input [N-1:0] num;
        begin
            sign = num[N-1];
        end
    endfunction

    
    function [N-1:0] abs;
        input [N-1:0] num;
        begin
            abs = num ^ sign(num);
        end
    endfunction

    
    function [N-1:0] add;
        input [N-1:0] a, b;
        begin
            add = a + b;
        end
    endfunction

    
    function [N-1:0] subtract;
        input [N-1:0] a, b;
        begin
            subtract = a - b;
        end
    endfunction

    
    always @(*) begin
        
        reg [N-1:0] sign_a = sign(a);
        reg [N-1:0] sign_b = sign(b);

        
        reg [N-1:0] abs_a = abs(a);
        reg [N-1:0] abs_b = abs(b);

        
        if (sign_a == sign_b) begin
            
            res = add(abs_a, abs_b);
            
            res[N-1] = sign_a;
        end else begin
            
            if (abs_a > abs_b) begin
                
                res = subtract(a, b);
                
                res[N-1] = 0;
            end else begin
                
                res = subtract(b, a);
                
                res[N-1] = (res == 0) ? 0 : 1;
            end
        end

        
        c = res;
    end

endmodule
