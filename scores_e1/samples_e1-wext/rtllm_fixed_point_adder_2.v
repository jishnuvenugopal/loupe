
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

parameter Q = 8;
 
parameter N = 16;
 

reg [N-1:0] res;
 

always @(a, b) begin
    
    reg [1:0] sign = a[0] ^ b[0];

    
    reg [N-1:0] abs_a = a;
    reg [N-1:0] abs_b = b;

    
    if (abs_a[0] == abs_b[0]) begin
        res = abs_a + abs_b;
    end else begin
        
        if (abs_a > abs_b) begin
            res = abs_a - abs_b;
            sign = 0;
 
        end else begin
            res = abs_b - abs_a;
            sign = 1;
 
        end
    end

    
    if (res[Q] == 1) begin
        
        res = res - 2**Q;
 
    end

    
    c = res[0] ^ sign;
end

endmodule
