
module fixed_point_adder (
    input wire [Q-1:0] Q,
    input wire [N-1:0] N,
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output wire [N-1:0] c
);

    
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
                sign_res <= sign_a;
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
            sign_res <= 0;
        end else begin
            if (abs_res == 0) begin
                sign_res <= 0;
            end else if (abs_res[Q] == 1) begin
                sign_res <= 1;
            end else begin
                sign_res <= 0;
            end
        end
    end

    
    assign c = res;

endmodule
