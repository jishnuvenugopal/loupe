
module fixed_point_adder #(parameter Q=8, parameter N=16) (
    input [N-1:0] a,
    input [N-1:0] b,
    output reg [N-1:0] c
);

    reg [N:0] carry;
    reg [N-1:0] abs_a;
    reg [N-1:0] abs_b;
    reg [N-1:0] result;

    
    assign abs_a = (a[N] == 1'b1) ? ~a + 1 : a;
    assign abs_b = (b[N] == 1'b1) ? ~b + 1 : b;

    always @(*) begin
        if (a[N] == b[N]) begin
            
            result = abs_a + abs_b;
            c[N] = a[N];
 
        end else begin
            
            if (abs_a > abs_b) begin
                result = abs_a - abs_b;
                c[N] = 0;
 
            end else begin
                result = abs_b - abs_a;
                c[N] = (abs_b > abs_a) ? 1 : 0;
 
            end
        end
    end

    assign c[N-1:0] = result[N-1:0];

endmodule
