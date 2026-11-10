
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c,
    input wire [N-1:0] Q
);

parameter N = 16;
 

reg [N-1:0] res;
reg [N-1:0] sign_a, sign_b;
reg [N-1:0] abs_a, abs_b, abs_res;
reg [N-1:0] overflow;

always @(*) begin
    
    sign_a = a[Q];
    sign_b = b[Q];

    
    abs_a = a;
    abs_b = b;

    
    if (sign_a == sign_b) begin
        
        abs_res = abs_a + abs_b;
        
        c = abs_res[Q];
    end else begin
        
        if (abs_a > abs_b) begin
            abs_res = abs_a - abs_b;
            
            c = abs_res[Q];
        end else begin
            abs_res = abs_b - abs_a;
            
            if (abs_res == 0) begin
                c = 0;
            end else begin
                c = ~abs_res[Q];
            end
        end
    end

    
    if (abs_res[Q] == 1 && (sign_a == 1 && sign_b == 0) || (sign_a == 0 && sign_b == 1)) begin
        overflow = 1;
    end else begin
        overflow = 0;
    end
end

endmodule
