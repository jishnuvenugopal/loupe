
module fixed_point_adder #(
    parameter Q = 4, 
    parameter N = 8  
) (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    
    reg [N-1:0] res;

    
    function logic sign (input wire [N-1:0] x);
        sign = x[N-1];
    endfunction

    
    function logic [N-1:0] abs (input wire [N-1:0] x);
        abs = (x >= 0) ? x : -x;
    endfunction

    
    function logic [N-1:0] max_abs (input wire [N-1:0] x, input wire [N-1:0] y);
        max_abs = (abs(x) > abs(y)) ? x : y;
    endfunction

    
    function logic [N-1:0] min_abs (input wire [N-1:0] x, input wire [N-1:0] y);
        min_abs = (abs(x) < abs(y)) ? x : y;
    endfunction

    
    function logic result_sign (input wire [N-1:0] x, input wire [N-1:0] y);
        result_sign = (sign(x) == sign(y)) ? sign(x) : 1'b1;
 
    endfunction

    
    function logic [N-1:0] add_sub (input wire [N-1:0] x, input wire [N-1:0] y, input wire [N-1:0] sign);
        logic [N-1:0] result;
        if (sign) begin
            result = x - y;
 
        end else begin
            result = x + y;
 
        end
        return result;
    endfunction

    
    always_comb begin
        
        logic result_sign_val = result_sign(a, b);

        
        logic [N-1:0] max_abs_val = max_abs(a, b);

        
        logic [N-1:0] min_abs_val = min_abs(a, b);

        
        if (abs(a) == abs(b)) begin
            
            res = add_sub(a, b, sign(a));
        end else if (abs(a) > abs(b)) begin
            
            res = add_sub(a, b, sign(a));
        } else begin
            
            res = add_sub(b, a, sign(b));
        end

        
        res[N-1] = result_sign_val;
    end

    
    assign c = res;

endmodule
