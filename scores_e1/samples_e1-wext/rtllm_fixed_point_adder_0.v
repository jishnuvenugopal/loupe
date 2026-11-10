
module fixed_point_adder (
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    output reg [N-1:0] c
);

    localparam Q = 8;
 
    localparam N = 16;
 

    reg [N-1:0] res;

    always @(a, b) begin
        
        reg [1:0] sign = (a[Q] == b[Q]) ? 2'b00 : (a[Q] > b[Q]) ? 2'b01 : 2'b10;

        
        reg [N-1:0] abs_a = a[Q+1:N];
        reg [N-1:0] abs_b = b[Q+1:N];
        reg [N-1:0] abs_res;

        if (sign == 2'b00) begin
            abs_res = abs_a + abs_b;
        end else if (sign == 2'b01) begin
            abs_res = abs_a - abs_b;
        end else begin
            abs_res = abs_b - abs_a;
        end

        
        if (abs_res[Q] == 1'b1) begin
            if (sign == 2'b00) begin
                abs_res = abs_res - 1'b1;
            end else begin
                abs_res = abs_res + 1'b1;
            end
        end

        
        res = abs_res << Q;
    end

    assign c = res;

endmodule
