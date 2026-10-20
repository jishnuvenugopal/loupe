
module fixed_point_adder #(
    parameter Q = 4, 
    parameter N = 8  
) (
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    
    reg [N-1:0] res;

    
    wire [Q-1:0] a_frac = a[N-1:Q];
    wire [Q-1:0] b_frac = b[N-1:Q];
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    
    always @(*) begin
        if (a_sign == b_sign) begin
            
            res = a + b;
            c[N-1] = a_sign;
 
        end else begin
            
            if (a_frac > b_frac) begin
                
                res = a - b;
                c[N-1] = 0;
 
            end else begin
                
                res = b - a;
                c[N-1] = b_sign;
 
            end
        end
    end

endmodule
