
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    parameter N = 16;
 
    parameter Q = 8;
  

    reg [N-1:0] res;
  
    reg [N-1:0] abs_a;
 
    reg [N-1:0] abs_b;
 
    reg [N-1:0] abs_res;
 
    reg [1:0] sign_a;
  
    reg [1:0] sign_b;
  
    reg [1:0] sign_res;
 

    
    assign abs_a = a;
    assign abs_b = b;

    
    assign sign_a = a[Q];
    assign sign_b = b[Q];

    
    always @(posedge clk) begin
        if (reset) begin
            res <= 0;
            abs_res <= 0;
            sign_res <= 0;
        end else begin
            if (sign_a == sign_b) begin
                
                abs_res <= abs_a + abs_b;
                if (abs_res[Q]) begin
                    res <= abs_res;
                    sign_res <= 1;
                end else begin
                    res <= abs_res;
                    sign_res <= 0;
                end
            end else begin
                
                if (abs_a > abs_b) begin
                    abs_res <= abs_a - abs_b;
                    sign_res <= 0;
                end else begin
                    abs_res <= abs_b - abs_a;
                    sign_res <= 1;
                end
            end
        end
    end

    
    always @(posedge clk) begin
        if (reset) begin
            c <= 0;
        end else begin
            if (sign_res == 1) begin
                
                if (res[Q]) begin
                    c <= res;
                end else begin
                    c <= res;
                end
            end else begin
                
                if (res[Q]) begin
                    c <= res;
                end else begin
                    c <= res;
                end
            end
        end
    end

endmodule
