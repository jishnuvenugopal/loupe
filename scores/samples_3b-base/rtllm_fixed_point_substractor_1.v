
module fixed_point_subtractor #(
    parameter Q = 8,  
    parameter N = 16   
) (
    input [N-1:0] a,  
    input [N-1:0] b,  
    output [N-1:0] c   
);

    
    reg [N-1:0] res;
  

    
    reg [Q-1:0] a_sign = a[N-1];
  
    reg [Q-1:0] b_sign = b[N-1];
  

    
    reg [N-1:0] abs_a = a;
    reg [N-1:0] abs_b = b;

    
    if (a_sign != b_sign) begin
        if (a > b) begin
            res = abs_a - abs_b;
            c[N-1] = 1;
  
        end else begin
            res = abs_b - abs_a;
            c[N-1] = 0;
  
        end
    end else begin
        
        res = a - b;
        c[N-1] = a_sign;
  
    end

    
    if (res == 0) begin
        c[N-1] = 0;
  
    end

endmodule
