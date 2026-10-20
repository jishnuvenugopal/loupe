
module fixed_point_subtractor (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    
    parameter Q = 4;
 
    parameter N = 8;
 

    
    reg [N-1:0] res;

    
    wire a_sign = a[N-1];
    wire b_sign = b[N-1];

    
    reg [N-1:0] abs_a = a;
    reg [N-1:0] abs_b = b;

    
    if (a_sign != b_sign) begin
        if (a > b) begin
            res = abs_a - abs_b;
            c[N-1] = 1'b1;
 
        end else begin
            res = abs_b - abs_a;
            c[N-1] = 1'b0;
 
        end
    end else begin
        
        res = a - b;
    end

    
    if (res == 0) begin
        c[N-1] = 1'b0;
 
    end

endmodule
